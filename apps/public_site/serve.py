#!/usr/bin/env python3
"""SPA-friendly static server: 404'leri index.html'e yönlendirir."""
import os, sys
from http.server import HTTPServer, SimpleHTTPRequestHandler

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 5080

class SPAHandler(SimpleHTTPRequestHandler):
    def send_error(self, code, message=None, explain=None):
        if code == 404:
            self.path = '/index.html'
            return self.do_GET()
        super().send_error(code, message, explain)

    def log_message(self, fmt, *args):
        pass  # sessiz mod

os.chdir(os.path.join(os.path.dirname(__file__), 'build', 'web'))
print(f"Serving at http://localhost:{PORT}", flush=True)
HTTPServer(('', PORT), SPAHandler).serve_forever()
