SAMPLES.md: src/uuidv8.erl VERSION gen_uuid
	@echo "# Sample UUIDs\n\n" > $@
	./gen_uuid v1 1 >> $@
	./gen_uuid v4 4 >> $@
	./gen_uuid v6 6 >> $@
	./gen_uuid v7 7 >> $@
	./gen_uuid v8 0x01D 8 >> $@
	./gen_uuid v8node 0x0D3 8 >> $@	
	./gen_uuid v8+ 0x123 8 >> $@
	./gen_uuid v8* 8 >> $@