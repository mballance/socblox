/****************************************************************************
 * svf_dpi_pkg.sv
 ****************************************************************************/

/**
 * Package: svf_dpi_pkg
 * 
 * TODO: Add package documentation
 */
package svf_pkg;
	class svf_thread_mutex;
		semaphore			sem = new(1);
		
		task lock();
			sem.get(1);
		endtask
		
		task unlock();
			sem.put(1);
		endtask
	endclass
	
	class svf_wait_ev;
		bit					m_triggered;
		event				m_ev;
		
		svf_wait_ev			m_next;
	endclass
	
	class svf_thread_cond;
		svf_wait_ev			m_waiters;
		
		task cond_wait(svf_thread_mutex m);
			svf_wait_ev waiter = new;
			waiter.m_next = m_waiters;
			m_waiters = waiter;
		
			m.unlock();
			@(waiter.m_ev);
			m.lock();
		endtask
		
		task cond_notify();
			if (m_waiters != null) begin
				svf_wait_ev waiter = m_waiters;
				m_waiters = m_waiters.m_next;
				->waiter.m_ev;
			end
		endtask

		task cond_notify_all();
			while (m_waiters != null) begin
				svf_wait_ev waiter = m_waiters;
				m_waiters = m_waiters.m_next;
				->waiter.m_ev;
			end
		endtask
		
	endclass

	process						prv_proclist[$];
	svf_thread_mutex			prv_mutexlist[$];
	svf_thread_cond				prv_condlist[$];
	
	import "DPI-C" context task svf_dpi_create_thread_trampoline(chandle hndl);

	task svf_dpi_int_launcher(input chandle hndl, output process p);
		automatic process p_tmp;
		automatic mailbox #(process) sem = new(0);

		fork
			begin
				automatic process p = process::self();
				sem.put(p);
				svf_dpi_create_thread_trampoline(hndl);
			end
		join_none

		sem.get(p_tmp);
	endtask
	
	task svf_dpi_create_thread(input chandle hndl, output int unsigned out_p);
		automatic process p_tmp;
		automatic mailbox #(process) sem = new(0);
		
		svf_dpi_int_launcher(hndl, p_tmp);	

		prv_proclist.push_back(p_tmp);
		out_p = prv_proclist.size();
	endtask
	export "DPI-C" task svf_dpi_create_thread;
	
	function int unsigned svf_dpi_create_mutex();
		automatic int unsigned mutex_id;
		automatic svf_thread_mutex m = new();
	
		prv_mutexlist.push_back(m);
		mutex_id = prv_mutexlist.size();
		
		return mutex_id;
	endfunction
	export "DPI-C" function svf_dpi_create_mutex;
	
	task svf_dpi_mutex_lock(int unsigned mutex_id);
		automatic svf_thread_mutex m = prv_mutexlist[mutex_id-1];
		m.lock();
	endtask
	export "DPI-C" task svf_dpi_mutex_lock;
	
	task svf_dpi_mutex_unlock(int unsigned mutex_id);
		automatic svf_thread_mutex m = prv_mutexlist[mutex_id-1];
		m.unlock();
	endtask
	export "DPI-C" task svf_dpi_mutex_unlock;
	
	function int unsigned svf_dpi_create_cond();
		automatic int unsigned cond_id;
		automatic svf_thread_cond c = new();
		
		prv_condlist.push_back(c);
		cond_id = prv_condlist.size();
		
		return cond_id;
	endfunction
	export "DPI-C" function svf_dpi_create_cond;
	
	task svf_dpi_cond_wait(int unsigned cond_id, int unsigned mutex_id);
		automatic svf_thread_cond c = prv_condlist[cond_id-1];
		automatic svf_thread_mutex m = prv_mutexlist[mutex_id-1];
		c.cond_wait(m);
	endtask
	export "DPI-C" task svf_dpi_cond_wait;
	
	task svf_dpi_cond_notify(int unsigned cond_id);
		automatic svf_thread_cond c = prv_condlist[cond_id-1];
		c.cond_notify();
	endtask
	export "DPI-C" task svf_dpi_cond_notify;
	
	task svf_dpi_cond_notify_all(int unsigned cond_id);
		automatic svf_thread_cond c = prv_condlist[cond_id-1];
		c.cond_notify_all();
	endtask
	export "DPI-C" task svf_dpi_cond_notify_all;

	task svf_dpi_thread_yield();
		#0;
	endtask
	export "DPI-C" task svf_dpi_thread_yield;
	
	import "DPI-C" context task svf_dpi_runtest(string testname="");

	task svf_runtest(string testname="");
		#1;
		svf_dpi_runtest(testname);
	endtask
	

	import "DPI-C" context function int svf_dpi_init();
	static int init = svf_dpi_init();
	
	import "DPI-C" context svf_dpi_set_config_string = function void set_config_string(
			string path, string key, string val);

endpackage

