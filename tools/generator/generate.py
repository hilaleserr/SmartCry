#!/usr/bin/env python
"""SmartCry Project Generator
Simple CLI: generate project files from a short prompt.

Usage:
  python generate.py "flutter login screen" --out ./output
"""
from pathlib import Path
import sys
import shutil
from jinja2 import Environment, FileSystemLoader
import typer

app = typer.Typer()

TEMPLATES_DIR = Path(__file__).parent / "templates"


def render_template(template_name: str, dest: Path, context: dict):
    env = Environment(loader=FileSystemLoader(str(TEMPLATES_DIR)))
    tpl = env.get_template(template_name)
    content = tpl.render(**context)
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_text(content, encoding='utf-8')


@app.command()
def generate(prompt: str = typer.Argument(..., help="Natural language prompt"),
             out: Path = typer.Option(Path("./generated"), help="Output directory")):
    """Generate files based on a prompt. This is a simple rule-based mapper.
    """
    out = out.resolve()
    if out.exists():
        typer.echo(f"Output exists. Creating inside: {out}")
    else:
        out.mkdir(parents=True)

    # Very simple rule mapping
    p = prompt.lower()
    context = {'app_name': 'SmartCryGenerated'}

    if 'flutter' in p and 'login' in p:
        target_dir = out / 'flutter_login'
        shutil.copytree(TEMPLATES_DIR / 'flutter_login' / 'static', target_dir, dirs_exist_ok=True)
        # render main.dart
        render_template('flutter_login/main.dart.j2', target_dir / 'lib' / 'main.dart', context)
        typer.echo(f"Created Flutter login scaffold at {target_dir}")
    else:
        # fallback: create a README with the prompt
        readme = out / 'README_PROMPT.md'
        readme.write_text(f"# Generated from prompt\n\nPrompt: {prompt}\n", encoding='utf-8')
        typer.echo(f"No specific template matched. Wrote {readme}")


if __name__ == '__main__':
    app()
