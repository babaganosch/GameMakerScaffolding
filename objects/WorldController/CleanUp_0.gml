PERSISTENT_CLEANUP
unsubscribe();
delete receiver;

for (var _i = 0; _i < array_length(global.level); ++_i)
{
    global.level[_i].destroy();
}