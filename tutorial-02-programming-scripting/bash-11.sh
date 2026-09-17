#!/bin/bash
# =============================================================================
# backup_database.sh — Automated PostgreSQL backup with retention
# 
# Usage:
#   ./backup_database.sh [--db-name NAME] [--retention-days DAYS]
#
# Environment variables required:
#   DB_USER         PostgreSQL username
#   DB_PASSWORD     PostgreSQL password
#
# Examples:
#   ./backup_database.sh --db-name myapp_production --retention-days 14
# =============================================================================
