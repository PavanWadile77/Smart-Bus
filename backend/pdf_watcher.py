import os
import time
import glob
import subprocess

UPLOAD_DIR = os.path.join(os.path.dirname(__file__), 'uploads')
PROCESSED_DIR = os.path.join(os.path.dirname(__file__), 'processed')

def setup_dirs():
    os.makedirs(UPLOAD_DIR, exist_ok=True)
    os.makedirs(PROCESSED_DIR, exist_ok=True)

def watch():
    setup_dirs()
    print(f"Watching for new PDFs in {UPLOAD_DIR}...")
    
    while True:
        try:
            pdfs = glob.glob(os.path.join(UPLOAD_DIR, '*.pdf'))
            for pdf in pdfs:
                filename = os.path.basename(pdf)
                print(f"\n[WATCHER] Detected new PDF: {filename}")
                
                # Trigger the parser
                parser_script = os.path.join(os.path.dirname(__file__), 'pdf_parser.py')
                print(f"[WATCHER] Running parser...")
                
                # In a real system, you might pass the PDF path as an arg
                result = subprocess.run(['python', parser_script, pdf], capture_output=True, text=True)
                
                if result.returncode == 0:
                    print(f"[WATCHER] Parsing complete.")
                    # Move to processed
                    os.rename(pdf, os.path.join(PROCESSED_DIR, filename))
                else:
                    print(f"[WATCHER] Parser failed:\n{result.stderr}")
                    # Could move to 'failed' dir, but let's just leave it or rename to .error
                    os.rename(pdf, pdf + '.error')
                    
        except Exception as e:
            print(f"[WATCHER] Error: {e}")
            
        time.sleep(5)

if __name__ == "__main__":
    watch()
