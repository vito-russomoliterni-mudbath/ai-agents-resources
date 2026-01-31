#!/usr/bin/env python3
"""
Detect the test framework used in a project.

Usage:
    python detect_test_framework.py [project_path]

Returns:
    JSON object with framework name and confidence level
"""

import json
import os
import sys
from pathlib import Path
from typing import Dict, List, Optional, Tuple


def check_file_exists(base_path: Path, files: List[str]) -> bool:
    """Check if any of the given files exist in the base path."""
    return any((base_path / f).exists() for f in files)


def check_file_contains(file_path: Path, patterns: List[str]) -> bool:
    """Check if file contains any of the given patterns."""
    if not file_path.exists():
        return False
    try:
        content = file_path.read_text(encoding='utf-8', errors='ignore')
        return any(pattern in content for pattern in patterns)
    except Exception:
        return False


def detect_python_framework(base_path: Path) -> Optional[Tuple[str, int]]:
    """Detect Python testing framework. Returns (framework, confidence)."""
    # Check for pytest
    pytest_configs = ['pytest.ini', 'pyproject.toml', 'setup.cfg', 'tox.ini']
    if check_file_exists(base_path, pytest_configs):
        return ('pytest', 90)

    # Check for pytest in requirements
    req_files = ['requirements.txt', 'requirements-dev.txt', 'dev-requirements.txt']
    for req_file in req_files:
        if check_file_contains(base_path / req_file, ['pytest']):
            return ('pytest', 80)

    # Check for unittest patterns
    test_files = list(base_path.rglob('test*.py'))
    for test_file in test_files[:5]:  # Sample first 5 test files
        if check_file_contains(test_file, ['import unittest', 'from unittest']):
            return ('unittest', 70)

    # Default to pytest if test files exist
    if test_files:
        return ('pytest', 50)

    return None


def detect_javascript_framework(base_path: Path) -> Optional[Tuple[str, int]]:
    """Detect JavaScript/TypeScript testing framework. Returns (framework, confidence)."""
    # Check for vitest
    vitest_configs = ['vitest.config.ts', 'vitest.config.js', 'vite.config.ts']
    if check_file_exists(base_path, vitest_configs):
        return ('vitest', 90)

    # Check for jest
    jest_configs = ['jest.config.js', 'jest.config.ts', 'jest.config.json']
    if check_file_exists(base_path, jest_configs):
        return ('jest', 90)

    # Check package.json
    package_json = base_path / 'package.json'
    if package_json.exists():
        if check_file_contains(package_json, ['"vitest"']):
            return ('vitest', 85)
        if check_file_contains(package_json, ['"jest"']):
            return ('jest', 85)
        if check_file_contains(package_json, ['"mocha"']):
            return ('mocha', 85)
        if check_file_contains(package_json, ['"test":', 'vitest']):
            return ('vitest', 80)
        if check_file_contains(package_json, ['"test":', 'jest']):
            return ('jest', 80)

    # Check test files for imports
    test_files = list(base_path.rglob('*.test.ts')) + list(base_path.rglob('*.test.js'))
    for test_file in test_files[:5]:
        content_checks = [
            (['from "vitest"', 'from \'vitest\''], 'vitest', 75),
            (['from "jest"', '@jest'], 'jest', 75),
            (['from "mocha"', 'from \'mocha\''], 'mocha', 75),
        ]
        for patterns, framework, confidence in content_checks:
            if check_file_contains(test_file, patterns):
                return (framework, confidence)

    return None


def detect_dotnet_framework(base_path: Path) -> Optional[Tuple[str, int]]:
    """Detect .NET testing framework. Returns (framework, confidence)."""
    # Find .csproj files
    csproj_files = list(base_path.rglob('*.csproj'))

    for csproj in csproj_files:
        if check_file_contains(csproj, ['xunit', 'xUnit']):
            return ('xunit', 90)
        if check_file_contains(csproj, ['NUnit', 'nunit']):
            return ('nunit', 90)
        if check_file_contains(csproj, ['MSTest']):
            return ('mstest', 90)

    # Check test files
    test_files = list(base_path.rglob('*Test.cs')) + list(base_path.rglob('*Tests.cs'))
    for test_file in test_files[:5]:
        if check_file_contains(test_file, ['using Xunit', 'using xUnit']):
            return ('xunit', 80)
        if check_file_contains(test_file, ['using NUnit']):
            return ('nunit', 80)
        if check_file_contains(test_file, ['using Microsoft.VisualStudio.TestTools']):
            return ('mstest', 80)

    return None


def detect_java_framework(base_path: Path) -> Optional[Tuple[str, int]]:
    """Detect Java testing framework. Returns (framework, confidence)."""
    # Check for Maven
    if (base_path / 'pom.xml').exists():
        pom = base_path / 'pom.xml'
        if check_file_contains(pom, ['junit-jupiter', 'junit 5']):
            return ('junit5', 90)
        if check_file_contains(pom, ['junit', 'junit-vintage']):
            return ('junit4', 90)
        if check_file_contains(pom, ['testng']):
            return ('testng', 90)

    # Check for Gradle
    gradle_files = ['build.gradle', 'build.gradle.kts']
    for gradle_file in gradle_files:
        if (base_path / gradle_file).exists():
            gf = base_path / gradle_file
            if check_file_contains(gf, ['junit-jupiter', 'junit 5']):
                return ('junit5', 90)
            if check_file_contains(gf, ['junit:']):
                return ('junit4', 90)

    # Check test files
    test_files = list(base_path.rglob('*Test.java')) + list(base_path.rglob('*Tests.java'))
    for test_file in test_files[:5]:
        if check_file_contains(test_file, ['org.junit.jupiter', '@Test']):
            return ('junit5', 80)
        if check_file_contains(test_file, ['org.junit.Test', '@Test']):
            return ('junit4', 80)
        if check_file_contains(test_file, ['org.testng']):
            return ('testng', 80)

    return None


def detect_go_framework(base_path: Path) -> Optional[Tuple[str, int]]:
    """Detect Go testing framework. Returns (framework, confidence)."""
    # Go has built-in testing
    test_files = list(base_path.rglob('*_test.go'))
    if test_files:
        # Check if using testify
        for test_file in test_files[:5]:
            if check_file_contains(test_file, ['github.com/stretchr/testify']):
                return ('go-test-testify', 85)

        return ('go-test', 90)

    return None


def detect_test_framework(project_path: Optional[str] = None) -> Dict:
    """
    Detect the test framework used in a project.

    Args:
        project_path: Path to the project directory (defaults to current directory)

    Returns:
        Dictionary with 'framework', 'confidence', and 'language' keys
    """
    base_path = Path(project_path) if project_path else Path.cwd()

    if not base_path.exists():
        return {'error': f'Path does not exist: {base_path}'}

    # Try different language detectors in order of likelihood
    detectors = [
        ('python', detect_python_framework),
        ('javascript', detect_javascript_framework),
        ('dotnet', detect_dotnet_framework),
        ('java', detect_java_framework),
        ('go', detect_go_framework),
    ]

    results = []
    for language, detector in detectors:
        result = detector(base_path)
        if result:
            framework, confidence = result
            results.append({
                'language': language,
                'framework': framework,
                'confidence': confidence
            })

    if not results:
        return {
            'framework': 'unknown',
            'confidence': 0,
            'language': 'unknown',
            'message': 'No test framework detected'
        }

    # Return highest confidence result
    best = max(results, key=lambda x: x['confidence'])
    return best


def main():
    """CLI entry point."""
    project_path = sys.argv[1] if len(sys.argv) > 1 else None
    result = detect_test_framework(project_path)
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()
