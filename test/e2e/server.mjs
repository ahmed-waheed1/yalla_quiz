// Static server for build/web with an index.html fallback (the app uses the
// path URL strategy, so /lobby/K7XP2Q must serve index.html).
import http from 'node:http';
import { readFile, stat } from 'node:fs/promises';
import path from 'node:path';

const types = {
  '.js': 'text/javascript',
  '.mjs': 'text/javascript',
  '.html': 'text/html',
  '.json': 'application/json',
  '.wasm': 'application/wasm',
  '.png': 'image/png',
  '.ttf': 'font/ttf',
  '.otf': 'font/otf',
  '.css': 'text/css',
  '.svg': 'image/svg+xml',
};

export function serve(root, port) {
  const server = http.createServer(async (req, res) => {
    let p = path.join(root, decodeURIComponent(new URL(req.url, 'http://x').pathname));
    if (!p.startsWith(root)) p = path.join(root, 'index.html');
    try {
      if ((await stat(p)).isDirectory()) p = path.join(p, 'index.html');
    } catch {
      p = path.join(root, 'index.html');
    }
    let body;
    try {
      body = await readFile(p);
    } catch {
      res.writeHead(404);
      res.end();
      return;
    }
    res.writeHead(200, { 'content-type': types[path.extname(p)] || 'application/octet-stream' });
    res.end(body);
  });
  return new Promise((resolve) => server.listen(port, () => resolve(server)));
}
