# odin-track 

Simplest way I could think of adding a default tracking allocator to my odin projects. 

Just copy the files. On unix add to bash:

```
alias odin-track="cp /path/to/odin-track/*.odin $(pwd)"
```

## Future Ideas 

- Adding valgrind to have better profiling/debugging
- Custom tracking allocator that outputs to log file
