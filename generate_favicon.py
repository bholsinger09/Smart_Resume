#!/usr/bin/env python3
"""Generate small favicon"""
from PIL import Image, ImageDraw

img = Image.new('RGB', (16, 16), color='#1f2937')
draw = ImageDraw.Draw(img)
# Draw a simple circle
draw.ellipse([2, 2, 14, 14], fill='#3b82f6')
img.save('rails_app/public/favicon-16x16.png', 'PNG')
print("✓ Created favicon-16x16.png")
