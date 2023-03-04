PERSISTENT_CLEANUP
unsubscribe();
delete receiver;

for (var i = 0; i < array_length(global.level); ++i)
{
    global.level[i].destroy();
}