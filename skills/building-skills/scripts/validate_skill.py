#!/usr/bin/env python3
"""
Validates SKILL.md format for Claude Code and Codex compatibility.

Usage:
    python validate_skill.py <path-to-skill-directory>
"""

import os
import sys
import re
import yaml

def validate_skill(skill_dir):
    """Validate skill directory structure and SKILL.md format."""
    errors = []
    warnings = []
    
    # Check directory exists
    if not os.path.isdir(skill_dir):
        errors.append(f"Directory not found: {skill_dir}")
        return errors, warnings
    
    # Check SKILL.md exists
    skill_md_path = os.path.join(skill_dir, "SKILL.md")
    if not os.path.isfile(skill_md_path):
        errors.append("SKILL.md file not found")
        return errors, warnings
    
    # Read SKILL.md
    with open(skill_md_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Check frontmatter
    if not content.startswith('---'):
        errors.append("SKILL.md must start with YAML frontmatter (---)")
        return errors, warnings
    
    # Extract frontmatter
    parts = content.split('---', 2)
    if len(parts) < 3:
        errors.append("Invalid frontmatter format (must have opening and closing ---)")
        return errors, warnings
    
    frontmatter_text = parts[1].strip()
    body = parts[2].strip()
    
    # Parse YAML frontmatter
    try:
        frontmatter = yaml.safe_load(frontmatter_text)
    except yaml.YAMLError as e:
        errors.append(f"Invalid YAML in frontmatter: {e}")
        return errors, warnings
    
    # Validate required fields
    if 'name' not in frontmatter:
        errors.append("Missing required field: name")
    else:
        name = frontmatter['name']
        # Validate name format
        if not re.match(r'^[a-z0-9-]+$', name):
            errors.append(f"Invalid name format: {name} (must be lowercase letters, numbers, hyphens only)")
        if len(name) > 64:
            errors.append(f"Name too long: {len(name)} characters (max 64)")
    
    if 'version' not in frontmatter:
        errors.append("Missing required field: version")
    
    if 'description' not in frontmatter:
        errors.append("Missing required field: description")
    else:
        description = frontmatter['description']
        if len(description) < 10:
            warnings.append("Description is very short (should be comprehensive)")
        if len(description) > 1024:
            errors.append(f"Description too long: {len(description)} characters (max 1024)")
        
        # Check for third-person format
        if not description.lower().startswith("this skill should be used when"):
            errors.append("Description must use third-person format: 'This skill should be used when...'")
        
        # Check for exact trigger phrases (quoted phrases)
        if not re.search(r'["\'][^"\']+["\']', description):
            warnings.append("Description should include exact trigger phrases in quotes (e.g., 'convert a workflow')")
    
    # Check for body content
    if len(body) < 100:
        warnings.append("SKILL.md body is very short")
    
    lines = body.split('\n')
    if len(lines) > 500:
        warnings.append(f"SKILL.md body is long ({len(lines)} lines). Consider splitting into references.")
    
    # Check for common mistakes
    if 'readme' in [f.lower() for f in os.listdir(skill_dir)]:
        warnings.append("README.md found - skills typically don't need separate README files")
    
    if 'changelog' in [f.lower() for f in os.listdir(skill_dir)]:
        warnings.append("CHANGELOG found - avoid extra documentation files in skills")
    
    # Validate directory structure
    valid_dirs = ['scripts', 'references', 'assets']
    for item in os.listdir(skill_dir):
        item_path = os.path.join(skill_dir, item)
        if os.path.isdir(item_path) and item not in valid_dirs and not item.startswith('.'):
            warnings.append(f"Unexpected directory: {item} (standard dirs: scripts, references, assets)")
    
    return errors, warnings

def main():
    if len(sys.argv) != 2:
        print("Usage: python validate_skill.py <path-to-skill-directory>")
        sys.exit(1)
    
    skill_dir = sys.argv[1]
    errors, warnings = validate_skill(skill_dir)
    
    print(f"\nValidating skill: {skill_dir}\n")
    
    if errors:
        print("❌ ERRORS:")
        for error in errors:
            print(f"  - {error}")
    
    if warnings:
        print("\n⚠️  WARNINGS:")
        for warning in warnings:
            print(f"  - {warning}")
    
    if not errors and not warnings:
        print("✅ Skill validation passed!")
    
    if errors:
        print("\n❌ Validation failed")
        sys.exit(1)
    else:
        print("\n✅ Validation successful")
        sys.exit(0)

if __name__ == "__main__":
    main()
