#!/usr/bin/env node
"use strict";

// Fails a deploy when index.html points at a media file that is not in this
// tree, or (with --base) when that file is not HTTP 200 on a deployment.
// vercel.json buildCommand runs this with no args. scripts/deploy.sh runs it
// again with --base against the new deployment before aliasing the public site.

const fs = require("fs");
const path = require("path");
const { execFileSync } = require("child_process");

const root = path.resolve(__dirname, "..");
const indexPath = path.join(root, "index.html");
const MEDIA = /\.(mp4|webm|mov|m4v|wav|mp3|ogg|m4a|jpg|jpeg|png|webp|gif)$/i;

function parseArgs(argv) {
  let base = process.env.CHECK_MEDIA_BASE || "";
  for (let i = 2; i < argv.length; i++) {
    if (argv[i] === "--base") {
      base = argv[i + 1] || "";
      i += 1;
    } else if (argv[i] === "--help") {
      console.log(
        "usage: node scripts/check-linked-media.js [--base https://deployment.vercel.app]"
      );
      process.exit(0);
    } else {
      console.error("unknown arg: " + argv[i]);
      process.exit(2);
    }
  }
  return { base: base.replace(/\/$/, "") };
}

function linkedPaths(html) {
  const out = new Set();
  const re = /\b(?:src|poster|href)\s*=\s*["']([^"']+)["']/gi;
  let match;
  while ((match = re.exec(html))) {
    const raw = match[1].trim();
    if (
      !raw ||
      raw.startsWith("#") ||
      raw.startsWith("mailto:") ||
      raw.startsWith("data:")
    ) {
      continue;
    }
    let pathname = "";
    if (/^https?:\/\//i.test(raw)) {
      try {
        pathname = new URL(raw).pathname;
      } catch {
        continue;
      }
    } else {
      pathname = raw.split(/[?#]/)[0];
    }
    try {
      pathname = decodeURIComponent(pathname);
    } catch {
      throw new Error("bad encoding in media link: " + raw);
    }
    pathname = pathname.replace(/^\/+/, "");
    if (!MEDIA.test(pathname)) continue;
    if (pathname.split("/").includes("..")) {
      throw new Error("refusing path traversal: " + pathname);
    }
    out.add(pathname);
  }
  return [...out].sort();
}

function isLfsPointer(file) {
  const fd = fs.openSync(file, "r");
  try {
    const buf = Buffer.alloc(80);
    const n = fs.readSync(fd, buf, 0, 80, 0);
    return buf
      .slice(0, n)
      .toString("utf8")
      .startsWith("version https://git-lfs.github.com/spec/v1");
  } finally {
    fs.closeSync(fd);
  }
}

function gitIgnored(rel) {
  try {
    execFileSync("git", ["check-ignore", "-q", "--", rel], {
      cwd: root,
      stdio: "ignore",
    });
    return true;
  } catch (err) {
    if (err && err.status === 1) return false;
    return false;
  }
}

async function headStatus(url) {
  const res = await fetch(url, {
    method: "HEAD",
    redirect: "follow",
    headers: { "Cache-Control": "no-cache" },
  });
  if (res.status === 405 || res.status === 501) {
    const ranged = await fetch(url, {
      method: "GET",
      redirect: "follow",
      headers: { Range: "bytes=0-0", "Cache-Control": "no-cache" },
    });
    return ranged.status === 206 ? 200 : ranged.status;
  }
  return res.status;
}

function mediaUrl(base, rel) {
  const encoded = rel.split("/").map(encodeURIComponent).join("/");
  return base + "/" + encoded;
}

async function main() {
  const { base } = parseArgs(process.argv);
  if (!fs.existsSync(indexPath)) {
    console.error("missing index.html");
    process.exit(1);
  }
  const paths = linkedPaths(fs.readFileSync(indexPath, "utf8"));
  if (paths.length === 0) {
    console.error("no media links in index.html");
    process.exit(1);
  }

  const problems = [];
  for (const rel of paths) {
    const abs = path.join(root, rel);
    if (!fs.existsSync(abs) || !fs.statSync(abs).isFile()) {
      problems.push("missing " + rel);
      continue;
    }
    if (fs.statSync(abs).size === 0) {
      problems.push("empty " + rel);
      continue;
    }
    if (isLfsPointer(abs)) {
      problems.push("git-lfs pointer " + rel);
      continue;
    }
    if (gitIgnored(rel)) {
      problems.push("gitignored, so deploy would omit " + rel);
    }
  }
  if (problems.length) {
    console.error("linked media check failed:");
    for (const problem of problems) console.error("  " + problem);
    process.exit(1);
  }
  console.log("linked media on disk: " + paths.length + " files");

  if (!base) return;

  const httpProblems = [];
  for (const rel of paths) {
    const url = mediaUrl(base, rel);
    let status = 0;
    try {
      status = await headStatus(url);
    } catch (err) {
      httpProblems.push("request failed " + url + " (" + err.message + ")");
      continue;
    }
    if (status !== 200) httpProblems.push("HTTP " + status + " " + url);
    else console.log("200 " + rel);
  }
  if (httpProblems.length) {
    console.error("linked media HTTP check failed:");
    for (const problem of httpProblems) console.error("  " + problem);
    process.exit(1);
  }
  console.log("linked media HTTP 200: " + paths.length + " files");
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
