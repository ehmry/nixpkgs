preFixupPhases+=" absoluteLibrariesPreFixupPhase"

absoluteLibrariesPreFixupPhase() {
	if [ -n "${noAbsoluteLibraries:-}" ]; then return; fi

	find "${!outputBin}" "${!outputLib}" -type f | while read -r elf; do
		if patchelf "$elf" 2>/dev/null; then
			patchelf --print-rpath "$elf" | tr ':' '\n' | while read libdir; do
				echo "$(basename $elf) replace libs from $libdir"
				patchelf --print-needed "$elf" | while read lib; do
					case "$lib" in
					(ld*);;
					(/*);;
					(*)
						local libabs=$(realpath "$libdir/$lib" 2>/dev/null || true)
						if [ -f "$libabs" ]; then
							patchelf --replace-needed "$lib" "$libabs" "$elf"
						fi
						;;
					esac
				done
			done
		fi
	done
}
