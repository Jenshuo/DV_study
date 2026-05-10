/*
In the whole verification environment, there are many components running in parrell including
 - Generator class   -> task main()
 - Driver class      -> task main()
 - Monitor class     -> task main()
 - Scoreboard class  -> task main()
 - Environment class -> task main()
*/


task pre_test();
  drv.reset();
endtask


task test();
  fork
    gen.main();
    drv.main();
    mon.main();
    scb.main();
  join_any
endtask

task post_test();
  wait(done.triggered);                 // done : the event signal of the entire process generator completed
  wait(gen.count == drv.trans);         // the number of stimuli that we sent matches the number of transactions
  wait(gen.count == scb.trans);         // the number of stimuli that we sent matches the number of transactions we receive in a scoreboard
endtask


task run;
  // Pre-test : set your system into a reset
  pre_test();
  // Test : main task, gen, drv, monitor, scoreboard, env, etc.
  test();
  // Post test : waiting for all the processes to finish
  post_test();
  $finish;

endtask