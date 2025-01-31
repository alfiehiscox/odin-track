package main

import "core:fmt"
import "core:mem"
import "core:os"

main :: proc() {
	default := context.allocator
	tracking_allocator: mem.Tracking_Allocator
	mem.tracking_allocator_init(&tracking_allocator, default)
	defer mem.tracking_allocator_destroy(&tracking_allocator)
	context.allocator = mem.tracking_allocator(&tracking_allocator)
	defer print_memory_usage(&tracking_allocator)

}

print_memory_usage :: proc(tracking_allocator: ^mem.Tracking_Allocator, stats := false) {
	if stats {
		fmt.eprintln()
		fmt.eprintfln(
			"Total Allocated        : %d bytes",
			tracking_allocator.total_memory_allocated,
		)
		fmt.eprintfln("Total Freed            : %d bytes", tracking_allocator.total_memory_freed)
		fmt.eprintfln("Total Allocation Count : %d bytes", tracking_allocator.total_free_count)
		fmt.eprintfln("Total Free Count       : %d bytes", tracking_allocator.total_free_count)
		fmt.eprintfln(
			"Current Allocations    : %d bytes",
			tracking_allocator.current_memory_allocated,
		)
		fmt.eprintln()
	}

	if len(tracking_allocator.allocation_map) > 0 {
		fmt.eprintln("Memory Leaks: ")
		for _, entry in tracking_allocator.allocation_map {
			fmt.eprintf(" - Leaked %d @ %v\n", entry.size, entry.location)
		}
	}

	if len(tracking_allocator.bad_free_array) > 0 {
		fmt.eprintln("Bad Frees: ")
		for entry in tracking_allocator.bad_free_array {
			fmt.eprintf(" - Bad Free %p @ %v\n", entry.memory, entry.location)
		}
	}
}
