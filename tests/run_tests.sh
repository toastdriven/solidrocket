#!/bin/sh
echo "Running database tests..."
lua tests/database.lua
echo "Running utils tests..."
lua tests/utils.lua
echo "Done."
