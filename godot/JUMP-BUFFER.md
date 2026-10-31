# Landing jump buffer

Jump pressed during the final120ms before landing triggers the next jump on landing. An older airborne press expires. Start/restart clears it. Existing jump velocity/gravity are unchanged.

Also fixes an overpayment discovered in the parity audit: jumping no longer earns20points for unrelated low hazards in another lane or far behind the runner. The hazard must be crossed airborne in the same lane, then pay once.

New test_jump_buffer.gd covers buffered/expired presses and lane-specific one-time bonus. Existing systems, pause, migration, guardian, control, review and campaign tests pass; campaign8911frames zero retries. Actual browser normal Space input near descending height0.177 triggered a second jump without another press, zero errors. Inspected390x844 airborne screenshot. No public deployment.
