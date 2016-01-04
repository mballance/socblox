#!/bin/sh

for file in *.v; do
	grep -v 'timescale' $file > ${file}.1
	mv ${file}.1 ${file}
	sed -i -e 's/#1//g' ${file}
	sed -i -e 's/\bdo\b/data_out/g' ${file}
done

