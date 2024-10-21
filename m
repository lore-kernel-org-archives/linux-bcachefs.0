Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765A91E47BA;
	Mon, 21 Oct 2024 10:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506504; cv=none; b=g6RFjEBtmx/V52coHrVGBWUbGgL+P87C3K7ZN4jpN5QEaEGdhpv0XIr7VTyPzj8QCIX8JPCAbLsgE0VWKdkPikZxqAtcE6Wj3RX1uP1NmLtG48kMac46Z6bFOaIckUu5kSWijNlgmdSH93XoXG26lAeTfY0sEjeH/fIcLQoTWC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506504; c=relaxed/simple;
	bh=mViPVda6RbB5qysOWKco7IbnzCRsDPmSr8Ve6UC60zc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mO4aZTZnxeaA+GGZEsqErHZbnUsMyNik77j3a93LbJqZUWY/ySbwGdvGmnW2Ss/z9cyUV6hkrQ77XuIHZXV7QnGiqKxq1t7/ZuZqIfllt+ioeFWEGN9+QRDJYjM6FiUmYXw9bakwCewU5Z04RL6e/1nY52uvhqOn70Vh2RvJ/gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kzUDCVlG; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kzUDCVlG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729506501; x=1761042501;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=mViPVda6RbB5qysOWKco7IbnzCRsDPmSr8Ve6UC60zc=;
  b=kzUDCVlGgM4KSGp5dMcET+0yp7OQRwCUw04jibjSISBtuTN0IHFNngpz
   wAvI50hZf2TanpDsXMkWakornFtu70/6bCYDfgn5ivNBMplbPppiQSNCE
   kxW4OxXZir2dT9uT/LAXK216iydSlG8wd2d4UYxwyqJ/A3xzc2QbNbA57
   o4huZf4W0iRMAnUau6y10SWHz6wBKzfW0/zpzZZq9GemS7EelQhIXYpgj
   4zm41PSDrAHi5a+rPUERzed9dLxgyDEJhgmALxJdZMBpnhhZ0M09/EQl0
   MW8nKdgijFU6YjUBpdt1SBfnvbFTXGOYpl9aS56pVLiZHq8E8zeWoTV0J
   A==;
X-CSE-ConnectionGUID: MnpDsb07So+f7CULDlprlg==
X-CSE-MsgGUID: Dm5yCrIdQnesE98JjgO82g==
X-IronPort-AV: E=McAfee;i="6700,10204,11231"; a="16614223"
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="16614223"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2024 03:28:20 -0700
X-CSE-ConnectionGUID: EtLDXjsHQWqfM7ijEjz1CA==
X-CSE-MsgGUID: BTO0k8SoSUaQ5NMFND6VVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,220,1725346800"; 
   d="scan'208";a="84108005"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.161.23])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2024 03:28:19 -0700
Date: Mon, 21 Oct 2024 18:27:25 +0800
From: "Lai, Yi" <yi1.lai@linux.intel.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: [Syzkaller & bisect] There is INFO: task hung in __rq_qos_throttle
Message-ID: <ZxYsjXDsvsIt4wcR@ly-workstation>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Kent Overstreet,

Greetings!

I used Syzkaller and found that there is INFO: task hung in __rq_qos_throttle in v6.12-rc2

After bisection and the first bad commit is:
"
63332394c7e1 bcachefs: Move snapshot table size to struct snapshot_table
"

All detailed into can be found at:
https://github.com/laifryiee/syzkaller_logs/tree/main/241018_153537___rq_qos_throttle
Syzkaller repro code:
https://github.com/laifryiee/syzkaller_logs/tree/main/241018_153537___rq_qos_throttle/repro.c
Syzkaller repro syscall steps:
https://github.com/laifryiee/syzkaller_logs/tree/main/241018_153537___rq_qos_throttle/repro.prog
Syzkaller report:
https://github.com/laifryiee/syzkaller_logs/tree/main/241018_153537___rq_qos_throttle/repro.report
Kconfig(make olddefconfig):
https://github.com/laifryiee/syzkaller_logs/tree/main/241018_153537___rq_qos_throttle/kconfig_origin
Bisect info:
https://github.com/laifryiee/syzkaller_logs/tree/main/241018_153537___rq_qos_throttle/bisect_info.log
bzImage:
https://github.com/laifryiee/syzkaller_logs/raw/refs/heads/main/241018_153537___rq_qos_throttle/bzImage_8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
Issue dmesg:
https://github.com/laifryiee/syzkaller_logs/blob/main/241018_153537___rq_qos_throttle/8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b_dmesg.log

"
[  300.896887] INFO: task kworker/u8:1:31 blocked for more than 147 seconds.
[  300.897578]       Tainted: G        W          6.12.0-rc2-8cf0b93919e1 #1
[  300.897984] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  300.898431] task:kworker/u8:1    state:D stack:0     pid:31    tgid:31    ppid:2      flags:0x00004000
[  300.898985] Workqueue: writeback wb_workfn (flush-8:0)
[  300.899352] Call Trace:
[  300.899512]  <TASK>
[  300.899661]  __schedule+0xe13/0x33a0
[  300.899934]  ? __pfx___schedule+0x10/0x10
[  300.900181]  ? lock_release+0x441/0x870
[  300.900439]  ? __pfx_lock_release+0x10/0x10
[  300.900747]  ? trace_lock_acquire+0x139/0x1b0
[  300.901041]  ? __sanitizer_cov_trace_const_cmp4+0x1a/0x20
[  300.901374]  ? kthread_data+0x61/0xd0
[  300.901623]  schedule+0xf6/0x3f0
[  300.901850]  io_schedule+0xce/0x150
[  300.902081]  rq_qos_wait+0x1c5/0x310
[  300.902324]  ? __pfx_wbt_cleanup_cb+0x10/0x10
[  300.902602]  ? __pfx_rq_qos_wait+0x10/0x10
[  300.902883]  ? __pfx_lock_release+0x10/0x10
[  300.903149]  ? __pfx_rq_qos_wake_function+0x10/0x10
[  300.903460]  ? __pfx_wbt_inflight_cb+0x10/0x10
[  300.903744]  ? do_raw_spin_unlock+0x15c/0x210
[  300.904038]  wbt_wait+0x1ec/0x400
[  300.904243]  ? __pfx_wbt_wait+0x10/0x10
[  300.904480]  ? __pfx_dd_bio_merge+0x10/0x10
[  300.904805]  ? __pfx_wbt_wait+0x10/0x10
[  300.905055]  __rq_qos_throttle+0x5f/0xb0
[  300.905303]  blk_mq_submit_bio+0x8ad/0x2a20
[  300.905561]  ? __kasan_check_read+0x15/0x20
[  300.905837]  ? __pfx_blk_mq_submit_bio+0x10/0x10
[  300.906118]  ? __pfx_mark_lock.part.0+0x10/0x10
[  300.906404]  ? __this_cpu_preempt_check+0x21/0x30
[  300.906702]  ? __this_cpu_preempt_check+0x21/0x30
[  300.906977]  ? lock_release+0x441/0x870
[  300.907217]  __submit_bio+0x18d/0x500
[  300.907452]  ? __pfx___submit_bio+0x10/0x10
[  300.907705]  ? __this_cpu_preempt_check+0x21/0x30
[  300.907997]  ? seqcount_lockdep_reader_access.constprop.0+0xb4/0xd0
[  300.908380]  ? __sanitizer_cov_trace_const_cmp1+0x1e/0x30
[  300.908756]  ? kvm_clock_get_cycles+0x43/0x70
[  300.909061]  submit_bio_noacct_nocheck+0x6a0/0xcc0
[  300.909360]  ? __pfx_submit_bio_noacct_nocheck+0x10/0x10
[  300.909675]  submit_bio_noacct+0x61d/0x1dc0
[  300.909939]  submit_bio+0xce/0x480
[  300.910190]  ext4_io_submit+0xb0/0x150
[  300.910767]  ext4_do_writepages+0x1103/0x2f30
[  300.911455]  ? __pfx_ext4_do_writepages+0x10/0x10
[  300.912095]  ? rcu_is_watching+0x19/0xc0
[  300.912736]  ? __this_cpu_preempt_check+0x21/0x30
[  300.913438]  ? lock_is_held_type+0xef/0x150
[  300.914069]  ext4_writepages+0x35c/0x7c0
[  300.914648]  ? __pfx_ext4_writepages+0x10/0x10
[  300.915363]  ? __pfx_ext4_writepages+0x10/0x10
[  300.916023]  do_writepages+0x1c3/0x8a0
[  300.916605]  ? __pfx_do_writepages+0x10/0x10
[  300.917302]  ? __pfx_lock_release+0x10/0x10
[  300.917929]  ? __pfx_lock_release+0x10/0x10
[  300.918533]  __writeback_single_inode+0x124/0xe10
[  300.918875]  ? wbc_attach_and_unlock_inode+0x5a9/0x950
[  300.919200]  writeback_sb_inodes+0x63b/0x1000
[  300.919492]  ? __pfx_writeback_sb_inodes+0x10/0x10
[  300.919789]  ? lock_acquire.part.0+0x152/0x390
[  300.920113]  ? __sanitizer_cov_trace_const_cmp8+0x1c/0x30
[  300.920438]  __writeback_inodes_wb+0xc8/0x280
[  300.920759]  wb_writeback+0x717/0xaf0
[  300.921013]  ? __pfx_wb_writeback+0x10/0x10
[  300.921286]  ? __sanitizer_cov_trace_cmp4+0x1a/0x20
[  300.921586]  ? get_nr_dirty_inodes+0x12c/0x1b0
[  300.921881]  ? lockdep_hardirqs_on+0x89/0x110
[  300.922163]  wb_workfn+0x7b5/0xc90
[  300.922390]  ? __pfx_lock_acquire.part.0+0x10/0x10
[  300.922695]  ? __pfx_wb_workfn+0x10/0x10
[  300.922953]  ? rcu_is_watching+0x19/0xc0
[  300.923226]  process_one_work+0x92e/0x1b50
[  300.923490]  ? lock_acquire.part.0+0x152/0x390
[  300.923787]  ? __pfx_process_one_work+0x10/0x10
[  300.924071]  ? move_linked_works+0x1bf/0x2c0
[  300.924348]  ? __this_cpu_preempt_check+0x21/0x30
[  300.924655]  ? assign_work+0x19f/0x250
[  300.924931]  ? lock_is_held_type+0xef/0x150
[  300.925194]  worker_thread+0x68d/0xe90
[  300.925433]  ? lockdep_hardirqs_on+0x89/0x110
[  300.925718]  kthread+0x35a/0x470
[  300.925930]  ? __pfx_worker_thread+0x10/0x10
[  300.926202]  ? __pfx_kthread+0x10/0x10
[  300.926445]  ret_from_fork+0x56/0x90
[  300.926685]  ? __pfx_kthread+0x10/0x10
[  300.926920]  ret_from_fork_asm+0x1a/0x30
[  300.927181]  </TASK>
[  300.927327] INFO: task kworker/u8:2:35 blocked for more than 147 seconds.
[  300.927712]       Tainted: G        W          6.12.0-rc2-8cf0b93919e1 #1
[  300.928104] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  300.928547] task:kworker/u8:2    state:D stack:0     pid:35    tgid:35    ppid:2      flags:0x00004000
[  300.929167] Workqueue: writeback wb_workfn (flush-8:0)
[  300.929503] Call Trace:
[  300.929664]  <TASK>
[  300.929817]  __schedule+0xe13/0x33a0
[  300.930066]  ? __pfx___schedule+0x10/0x10
[  300.930322]  ? lock_release+0x441/0x870
[  300.930573]  ? __pfx_lock_release+0x10/0x10
[  300.930843]  ? trace_lock_acquire+0x139/0x1b0
[  300.931130]  ? __sanitizer_cov_trace_const_cmp4+0x1a/0x20
[  300.931461]  ? kthread_data+0x61/0xd0
[  300.931702]  schedule+0xf6/0x3f0
[  300.931929]  io_schedule+0xce/0x150
[  300.932152]  blk_mq_get_tag+0x5e7/0xce0
[  300.932403]  ? __pfx_blk_mq_get_tag+0x10/0x10
[  300.932710]  ? __pfx_wbt_cleanup_cb+0x10/0x10
[  300.932991]  ? __sanitizer_cov_trace_switch+0x58/0xa0
[  300.933301]  ? __pfx_autoremove_wake_function+0x10/0x10
[  300.933629]  ? __pfx_rq_qos_wake_function+0x10/0x10
[  300.933935]  ? __sanitizer_cov_trace_const_cmp4+0x1a/0x20
[  300.934262]  ? dd_limit_depth+0x21e/0x2a0
[  300.934516]  ? __pfx_dd_limit_depth+0x10/0x10
[  300.934790]  __blk_mq_alloc_requests+0x6f6/0x1720
[  300.935105]  ? __pfx___blk_mq_alloc_requests+0x10/0x10
[  300.935416]  ? __pfx_wbt_wait+0x10/0x10
[  300.935667]  blk_mq_submit_bio+0x93c/0x2a20
[  300.935942]  ? __pfx_blk_mq_submit_bio+0x10/0x10
[  300.936230]  ? lru_add_drain+0x21c/0x420
[  300.936471]  __submit_bio+0x18d/0x500
[  300.936737]  ? __pfx___submit_bio+0x10/0x10
[  300.937000]  ? mpage_prepare_extent_to_map+0xf66/0x13d0
[  300.937325]  ? __sanitizer_cov_trace_cmp8+0x1c/0x30
[  300.937628]  ? mpage_release_unused_pages+0x662/0x800
[  300.937969]  submit_bio_noacct_nocheck+0x6a0/0xcc0
[  300.938245]  ? __pfx_submit_bio_noacct_nocheck+0x10/0x10
[  300.938561]  ? lock_is_held_type+0xef/0x150
[  300.938822]  submit_bio_noacct+0x61d/0x1dc0
[  300.939087]  submit_bio+0xce/0x480
[  300.939302]  ext4_io_submit+0xb0/0x150
[  300.939549]  ext4_do_writepages+0xa54/0x2f30
[  300.939828]  ? __kasan_check_read+0x15/0x20
[  300.940096]  ? __this_cpu_preempt_check+0x21/0x30
[  300.940406]  ? __pfx_ext4_do_writepages+0x10/0x10
[  300.940729]  ? rcu_is_watching+0x19/0xc0
[  300.940999]  ? __this_cpu_preempt_check+0x21/0x30
[  300.941296]  ? lock_is_held_type+0xef/0x150
[  300.941570]  ext4_writepages+0x35c/0x7c0
[  300.941820]  ? __pfx_ext4_writepages+0x10/0x10
[  300.942125]  ? __pfx_ext4_writepages+0x10/0x10
[  300.942406]  do_writepages+0x1c3/0x8a0
[  300.942656]  ? __pfx_do_writepages+0x10/0x10
[  300.942932]  ? __pfx_lock_release+0x10/0x10
[  300.943195]  ? __pfx_lock_release+0x10/0x10
[  300.943468]  __writeback_single_inode+0x124/0xe10
[  300.943757]  ? wbc_attach_and_unlock_inode+0x5a9/0x950
[  300.944077]  writeback_sb_inodes+0x63b/0x1000
[  300.944367]  ? __pfx_writeback_sb_inodes+0x10/0x10
[  300.944659]  ? lock_acquire.part.0+0x152/0x390
[  300.945026]  ? __sanitizer_cov_trace_const_cmp8+0x1c/0x30
[  300.945355]  __writeback_inodes_wb+0xc8/0x280
[  300.945633]  wb_writeback+0x717/0xaf0
[  300.945882]  ? __pfx_wb_writeback+0x10/0x10
[  300.946152]  ? __sanitizer_cov_trace_cmp4+0x1a/0x20
[  300.946451]  ? get_nr_dirty_inodes+0x12c/0x1b0
[  300.946733]  ? lockdep_hardirqs_on+0x89/0x110
[  300.947009]  wb_workfn+0x7b5/0xc90
[  300.947214]  ? __pfx_lock_acquire.part.0+0x10/0x10
[  300.947519]  ? __pfx_wb_workfn+0x10/0x10
[  300.947754]  ? rcu_is_watching+0x19/0xc0
[  300.948014]  process_one_work+0x92e/0x1b50
[  300.948247]  ? lock_acquire.part.0+0x152/0x390
[  300.948500]  ? __pfx_process_one_work+0x10/0x10
[  300.948775]  ? move_linked_works+0x1bf/0x2c0
[  300.949026]  ? __this_cpu_preempt_check+0x21/0x30
[  300.949326]  ? assign_work+0x19f/0x250
[  300.949562]  ? lock_is_held_type+0xef/0x150
[  300.949835]  worker_thread+0x68d/0xe90
[  300.950087]  kthread+0x35a/0x470
[  300.950275]  ? __pfx_worker_thread+0x10/0x10
[  300.950686]  ? __pfx_kthread+0x10/0x10
[  300.951199]  ret_from_fork+0x56/0x90
[  300.951684]  ? __pfx_kthread+0x10/0x10
[  300.952202]  ret_from_fork_asm+0x1a/0x30
[  300.952853]  </TASK>
[  300.953222] INFO: task kworker/u8:3:52 blocked for more than 147 seconds.
[  300.954074]       Tainted: G        W          6.12.0-rc2-8cf0b93919e1 #1
[  300.954925] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  300.955887] task:kworker/u8:3    state:D stack:0     pid:52    tgid:52    ppid:2      flags:0x00004000
[  300.956759] Workqueue: writeback wb_workfn (flush-8:0)
[  300.957054] Call Trace:
[  300.957208]  <TASK>
[  300.957354]  __schedule+0xe13/0x33a0
[  300.957597]  ? __pfx___schedule+0x10/0x10
[  300.957853]  ? lock_release+0x441/0x870
[  300.958100]  ? __pfx_lock_release+0x10/0x10
[  300.958360]  ? trace_lock_acquire+0x139/0x1b0
[  300.958642]  ? __sanitizer_cov_trace_const_cmp4+0x1a/0x20
[  300.958973]  ? kthread_data+0x61/0xd0
[  300.959211]  schedule+0xf6/0x3f0
[  300.959426]  io_schedule+0xce/0x150
[  300.959654]  rq_qos_wait+0x1c5/0x310
[  300.959888]  ? __pfx_wbt_cleanup_cb+0x10/0x10
[  300.960157]  ? __pfx_rq_qos_wait+0x10/0x10
[  300.960417]  ? __pfx_lock_release+0x10/0x10
[  300.960701]  ? __pfx_rq_qos_wake_function+0x10/0x10
[  300.961005]  ? __pfx_wbt_inflight_cb+0x10/0x10
[  300.961288]  ? do_raw_spin_unlock+0x15c/0x210
[  300.961577]  wbt_wait+0x1ec/0x400
[  300.961800]  ? __pfx_wbt_wait+0x10/0x10
[  300.962038]  ? __pfx_dd_bio_merge+0x10/0x10
[  300.962290]  ? __pfx_wbt_wait+0x10/0x10
[  300.962525]  __rq_qos_throttle+0x5f/0xb0
[  300.962763]  blk_mq_submit_bio+0x8ad/0x2a20
[  300.963021]  ? __kasan_check_read+0x15/0x20
[  300.963288]  ? __pfx_blk_mq_submit_bio+0x10/0x10
[  300.963571]  ? __pfx_mark_lock.part.0+0x10/0x10
[  300.963860]  ? __this_cpu_preempt_check+0x21/0x30
[  300.964152]  ? __this_cpu_preempt_check+0x21/0x30
[  300.964437]  ? lock_release+0x441/0x870
[  300.964875]  __submit_bio+0x18d/0x500
[  300.965406]  ? __pfx___submit_bio+0x10/0x10
[  300.965989]  ? __this_cpu_preempt_check+0x21/0x30
[  300.966629]  ? seqcount_lockdep_reader_access.constprop.0+0xb4/0xd0
[  300.967478]  ? __sanitizer_cov_trace_const_cmp1+0x1e/0x30
[  300.968136]  ? kvm_clock_get_cycles+0x43/0x70
[  300.968416]  submit_bio_noacct_nocheck+0x6a0/0xcc0
[  300.968745]  ? __pfx_submit_bio_noacct_nocheck+0x10/0x10
[  300.969082]  ? __sanitizer_cov_trace_switch+0x58/0xa0
[  300.969345]  submit_bio_noacct+0x61d/0x1dc0
[  300.969589]  submit_bio+0xce/0x480
[  300.969805]  submit_bh_wbc+0x58a/0x740
[  300.970049]  __block_write_full_folio+0x7a1/0xed0
[  300.970332]  ? __pfx_blkdev_get_block+0x10/0x10
[  300.970615]  block_write_full_folio+0x2e6/0x3a0
[  300.970898]  ? __pfx_blkdev_get_block+0x10/0x10
[  300.971215]  ? __pfx_blkdev_get_block+0x10/0x10
[  300.971526]  write_cache_pages+0xbc/0x140
[  300.971807]  ? __pfx_block_write_full_folio+0x10/0x10
[  300.972153]  ? __pfx_write_cache_pages+0x10/0x10
[  300.972475]  ? __this_cpu_preempt_check+0x21/0x30
[  300.972839]  blkdev_writepages+0xa5/0xf0
[  300.973122]  ? __pfx_blkdev_writepages+0x10/0x10
[  300.973434]  ? __pfx_do_raw_spin_lock+0x10/0x10
[  300.973727]  ? do_raw_spin_unlock+0x15c/0x210
[  300.974009]  ? __pfx_blkdev_writepages+0x10/0x10
[  300.974295]  do_writepages+0x1c3/0x8a0
[  300.974542]  ? __pfx_do_writepages+0x10/0x10
[  300.974811]  ? __pfx_lock_release+0x10/0x10
[  300.975070]  ? lock_release+0x441/0x870
[  300.975325]  __writeback_single_inode+0x124/0xe10
[  300.975618]  ? wbc_attach_and_unlock_inode+0x5a9/0x950
[  300.975942]  writeback_sb_inodes+0x63b/0x1000
[  300.976227]  ? __pfx_writeback_sb_inodes+0x10/0x10
[  300.976521]  ? lock_acquire.part.0+0x152/0x390
[  300.976888]  ? __sanitizer_cov_trace_const_cmp8+0x1c/0x30
[  300.977212]  __writeback_inodes_wb+0xc8/0x280
[  300.977491]  wb_writeback+0x717/0xaf0
[  300.977726]  ? __pfx_wb_writeback+0x10/0x10
[  300.977986]  ? __sanitizer_cov_trace_cmp4+0x1a/0x20
[  300.978278]  ? __sanitizer_cov_trace_cmp4+0x1a/0x20
[  300.978560]  ? get_nr_dirty_inodes+0x12c/0x1b0
[  300.978843]  ? lockdep_hardirqs_on+0x89/0x110
[  300.979123]  wb_workfn+0x76c/0xc90
[  300.979349]  ? __pfx_lock_acquire.part.0+0x10/0x10
[  300.979646]  ? __pfx_wb_workfn+0x10/0x10
[  300.979878]  ? rcu_is_watching+0x19/0xc0
[  300.980133]  process_one_work+0x92e/0x1b50
[  300.980372]  ? lock_acquire.part.0+0x152/0x390
[  300.980644]  ? __pfx_process_one_work+0x10/0x10
[  300.980946]  ? move_linked_works+0x1bf/0x2c0
[  300.981213]  ? __this_cpu_preempt_check+0x21/0x30
[  300.981514]  ? assign_work+0x19f/0x250
[  300.981751]  ? lock_is_held_type+0xef/0x150
[  300.982023]  worker_thread+0x68d/0xe90
[  300.982260]  ? lockdep_hardirqs_on+0x89/0x110
[  300.982553]  kthread+0x35a/0x470
[  300.982760]  ? __pfx_worker_thread+0x10/0x10
[  300.983031]  ? __pfx_kthread+0x10/0x10
[  300.983276]  ret_from_fork+0x56/0x90
[  300.983505]  ? __pfx_kthread+0x10/0x10
[  300.983742]  ret_from_fork_asm+0x1a/0x30
[  300.984010]  </TASK>
[  300.984175] INFO: task jbd2/sda-8:104 blocked for more than 147 seconds.
[  300.984563]       Tainted: G        W          6.12.0-rc2-8cf0b93919e1 #1
[  300.984994] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  300.985440] task:jbd2/sda-8      state:D stack:0     pid:104   tgid:104   ppid:2      flags:0x00004000
[  300.985989] Call Trace:
[  300.986150]  <TASK>
[  300.986291]  __schedule+0xe13/0x33a0
[  300.986531]  ? __pfx___schedule+0x10/0x10
[  300.986780]  ? lock_release+0x441/0x870
[  300.987033]  ? __pfx_lock_release+0x10/0x10
[  300.987291]  ? trace_lock_acquire+0x139/0x1b0
[  300.987580]  ? lock_acquire+0x80/0xb0
[  300.987816]  ? schedule+0x216/0x3f0
[  300.988048]  schedule+0xf6/0x3f0
[  300.988256]  io_schedule+0xce/0x150
[  300.988478]  blk_mq_get_tag+0x5e7/0xce0
[  300.988755]  ? __pfx_blk_mq_get_tag+0x10/0x10
[  300.989031]  ? lock_release+0x441/0x870
[  300.989263]  ? __sanitizer_cov_trace_switch+0x58/0xa0
[  300.989567]  ? __pfx_autoremove_wake_function+0x10/0x10
[  300.989886]  ? blk_mq_sched_try_merge+0xce/0x650
[  300.990170]  ? __sanitizer_cov_trace_const_cmp1+0x1e/0x30
[  300.990495]  ? dd_limit_depth+0x21e/0x2a0
[  300.990750]  ? __pfx_dd_limit_depth+0x10/0x10
[  300.991026]  __blk_mq_alloc_requests+0x6f6/0x1720
[  300.991331]  ? __sanitizer_cov_trace_const_cmp4+0x1a/0x20
[  300.991663]  ? __pfx___blk_mq_alloc_requests+0x10/0x10
[  300.991987]  ? __pfx_wbt_wait+0x10/0x10
[  300.992238]  blk_mq_submit_bio+0x93c/0x2a20
[  300.992487]  ? __pfx___lock_acquire+0x10/0x10
[  300.992789]  ? __pfx_blk_mq_submit_bio+0x10/0x10
[  300.993055]  ? __this_cpu_preempt_check+0x21/0x30
[  300.993352]  ? __this_cpu_preempt_check+0x21/0x30
[  300.993642]  ? lock_release+0x441/0x870
[  300.993895]  __submit_bio+0x18d/0x500
[  300.994131]  ? __pfx___submit_bio+0x10/0x10
[  300.994392]  ? __this_cpu_preempt_check+0x21/0x30
[  300.994668]  ? seqcount_lockdep_reader_access.constprop.0+0xb4/0xd0
[  300.995045]  ? __sanitizer_cov_trace_const_cmp1+0x1e/0x30
[  300.995360]  ? kvm_clock_get_cycles+0x43/0x70
[  300.995634]  submit_bio_noacct_nocheck+0x6a0/0xcc0
[  300.995946]  ? __pfx_submit_bio_noacct_nocheck+0x10/0x10
[  300.996271]  ? __sanitizer_cov_trace_switch+0x58/0xa0
[  300.996584]  submit_bio_noacct+0x61d/0x1dc0
[  300.996886]  submit_bio+0xce/0x480
[  300.997108]  submit_bh_wbc+0x58a/0x740
[  300.997353]  submit_bh+0x2b/0x40
[  300.997567]  jbd2_journal_commit_transaction+0x2a09/0x65e0
[  300.997950]  ? __pfx_jbd2_journal_commit_transaction+0x10/0x10
[  300.998314]  ? __this_cpu_preempt_check+0x21/0x30
[  300.998612]  ? lock_release+0x441/0x870
[  300.998857]  ? __this_cpu_preempt_check+0x21/0x30
[  300.999148]  ? _raw_spin_unlock_irqrestore+0x45/0x70
[  300.999451]  ? __sanitizer_cov_trace_const_cmp4+0x1a/0x20
[  300.999797]  kjournald2+0x204/0x790
[  301.000031]  ? __pfx_kjournald2+0x10/0x10
[  301.000274]  ? lockdep_hardirqs_on+0x89/0x110
[  301.000536]  ? __pfx_autoremove_wake_function+0x10/0x10
[  301.000888]  ? __sanitizer_cov_trace_const_cmp1+0x1e/0x30
[  301.001216]  ? __kthread_parkme+0x15d/0x230
[  301.001480]  kthread+0x35a/0x470
[  301.001695]  ? __pfx_kjournald2+0x10/0x10
[  301.001954]  ? __pfx_kthread+0x10/0x10
[  301.002198]  ret_from_fork+0x56/0x90
[  301.002429]  ? __pfx_kthread+0x10/0x10
[  301.002672]  ret_from_fork_asm+0x1a/0x30
[  301.002946]  </TASK>
[  301.003116] INFO: task kworker/1:3:159 blocked for more than 147 seconds.
[  301.003510]       Tainted: G        W          6.12.0-rc2-8cf0b93919e1 #1
[  301.003905] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  301.004334] task:kworker/1:3     state:D stack:0     pid:159   tgid:159   ppid:2      flags:0x00004000
[  301.004908] Workqueue: events ata_scsi_dev_rescan
[  301.005222] Call Trace:
[  301.005382]  <TASK>
[  301.005531]  __schedule+0xe13/0x33a0
[  301.005780]  ? __pfx___schedule+0x10/0x10
[  301.006034]  ? lock_release+0x441/0x870
[  301.006285]  ? __pfx_lock_release+0x10/0x10
[  301.006557]  ? _raw_spin_unlock_irq+0x3c/0x60
[  301.006844]  schedule+0xf6/0x3f0
[  301.007064]  io_schedule+0xce/0x150
[  301.007295]  blk_mq_get_tag+0x5e7/0xce0
[  301.007552]  ? __pfx_blk_mq_get_tag+0x10/0x10
[  301.007838]  ? __pfx_autoremove_wake_function+0x10/0x10
[  301.008168]  __blk_mq_alloc_requests+0x6f6/0x1720
[  301.008461]  ? __sanitizer_cov_trace_const_cmp1+0x1e/0x30
[  301.008822]  ? __pfx___blk_mq_alloc_requests+0x10/0x10
[  301.009146]  blk_mq_alloc_request+0x655/0x930
[  301.009417]  ? __pfx_blk_mq_alloc_request+0x10/0x10
[  301.009718]  ? __lock_acquire+0xd87/0x5c90
[  301.009995]  scsi_execute_cmd+0x223/0x1040
[  301.010280]  ? __this_cpu_preempt_check+0x21/0x30
[  301.010576]  ? __pfx_scsi_execute_cmd+0x10/0x10
[  301.010859]  ? __pfx_lock_acquire.part.0+0x10/0x10
[  301.011158]  scsi_vpd_inquiry+0xdf/0x220
[  301.011408]  ? __pfx_scsi_vpd_inquiry+0x10/0x10
[  301.011680]  ? debug_smp_processor_id+0x20/0x30
[  301.011963]  ? rcu_is_watching+0x19/0xc0
[  301.012202]  scsi_get_vpd_size+0x11e/0x310
[  301.012449]  ? __mutex_lock+0x230/0x1490
[  301.012723]  ? __pfx_scsi_get_vpd_size+0x10/0x10
[  301.013010]  ? scsi_rescan_device+0x33/0x360
[  301.013282]  ? __pfx_mark_lock.part.0+0x10/0x10
[  301.013562]  ? __this_cpu_preempt_check+0x21/0x30
[  301.013864]  ? lock_acquire.part.0+0x152/0x390
[  301.014143]  ? __pfx___mutex_lock+0x10/0x10
[  301.014410]  scsi_get_vpd_buf+0x30/0x180
[  301.014662]  scsi_attach_vpd+0xf8/0x5b0
[  301.014923]  scsi_rescan_device+0x106/0x360
[  301.015191]  ata_scsi_dev_rescan+0x1d2/0x470
[  301.015465]  process_one_work+0x92e/0x1b50
[  301.015720]  ? lock_acquire.part.0+0x152/0x390
[  301.016012]  ? __pfx_process_one_work+0x10/0x10
[  301.016289]  ? move_linked_works+0x1bf/0x2c0
[  301.016554]  ? __this_cpu_preempt_check+0x21/0x30
[  301.016883]  ? assign_work+0x19f/0x250
[  301.017122]  ? lock_is_held_type+0xef/0x150
[  301.017378]  worker_thread+0x68d/0xe90
[  301.017632]  kthread+0x35a/0x470
[  301.017839]  ? __pfx_worker_thread+0x10/0x10
[  301.018096]  ? __pfx_kthread+0x10/0x10
[  301.018329]  ret_from_fork+0x56/0x90
[  301.018557]  ? __pfx_kthread+0x10/0x10
[  301.018796]  ret_from_fork_asm+0x1a/0x30
[  301.019060]  </TASK>
[  301.019215] INFO: task auditd:239 blocked for more than 147 seconds.
[  301.019613]       Tainted: G        W          6.12.0-rc2-8cf0b93919e1 #1
[  301.020441] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  301.021474] task:auditd          state:D stack:0     pid:239   tgid:239   ppid:1      flags:0x00000002
[  301.022670] Call Trace:
[  301.023030]  <TASK>
[  301.023349]  __schedule+0xe13/0x33a0
[  301.023877]  ? __pfx___schedule+0x10/0x10
[  301.024418]  ? lock_release+0x441/0x870
[  301.025023]  ? __pfx_lock_release+0x10/0x10
[  301.025396]  ? trace_lock_acquire+0x139/0x1b0
[  301.025730]  ? lock_acquire+0x80/0xb0
[  301.026009]  ? schedule+0x216/0x3f0
[  301.026283]  schedule+0xf6/0x3f0
[  301.026536]  io_schedule+0xce/0x150
[  301.026810]  bit_wait_io+0x1f/0x100
[  301.027083]  __wait_on_bit+0x68/0x1b0
[  301.027367]  ? __pfx_bit_wait_io+0x10/0x10
[  301.027698]  out_of_line_wait_on_bit+0xe6/0x120
[  301.028042]  ? __pfx_out_of_line_wait_on_bit+0x10/0x10
[  301.028353]  ? __pfx_wake_bit_function+0x10/0x10
[  301.028628]  ? __might_sleep+0xa3/0x170
[  301.028917]  do_get_write_access+0x83b/0x1010
[  301.029206]  jbd2_journal_get_write_access+0x1e4/0x270
[  301.029515]  __ext4_journal_get_write_access+0x72/0x3b0
[  301.029840]  ext4_reserve_inode_write+0x199/0x280
[  301.030130]  ? ext4_dirty_inode+0xeb/0x140
[  301.030386]  __ext4_mark_inode_dirty+0x18b/0x8c0
[  301.030672]  ? debug_smp_processor_id+0x20/0x30
[  301.030965]  ? __pfx___ext4_mark_inode_dirty+0x10/0x10
[  301.031270]  ? trace_jbd2_handle_start+0x77/0x210
[  301.031632]  ? jbd2__journal_start+0xff/0x6b0
[  301.032135]  ? __ext4_journal_start_sb+0x1f8/0x600
[  301.032641]  ? ext4_dirty_inode+0xb3/0x140
[  301.033200]  ? __pfx_ext4_dirty_inode+0x10/0x10
[  301.033704]  ext4_dirty_inode+0xeb/0x140
[  301.034227]  ? rcu_is_watching+0x19/0xc0
[  301.034752]  __mark_inode_dirty+0x1d0/0xd50
[  301.035318]  ? __pfx_generic_write_checks+0x10/0x10
[  301.036012]  generic_update_time+0xe0/0x110
[  301.036598]  file_modified+0x1af/0x1e0
[  301.037198]  ext4_buffered_write_iter+0x101/0x3e0
[  301.037855]  ext4_file_write_iter+0x8b8/0x1ab0
[  301.038476]  ? __pfx_lock_acquire.part.0+0x10/0x10
[  301.039152]  ? debug_smp_processor_id+0x20/0x30
[  301.039788]  ? __pfx_ext4_file_write_iter+0x10/0x10
[  301.040431]  ? __this_cpu_preempt_check+0x21/0x30
[  301.041109]  ? lock_is_held_type+0xef/0x150
[  301.041684]  vfs_write+0xc46/0x1120
[  301.042191]  ? __pfx_ext4_file_write_iter+0x10/0x10
[  301.042806]  ? __pfx_vfs_write+0x10/0x10
[  301.043377]  ? mutex_lock_nested+0x1f/0x30
[  301.043934]  ksys_write+0x14f/0x290
[  301.044421]  ? __pfx_ksys_write+0x10/0x10
[  301.044968]  __x64_sys_write+0x7b/0xc0
[  301.045200]  ? syscall_trace_enter+0x9b/0x230
[  301.045475]  x64_sys_call+0x1685/0x20d0
[  301.045720]  do_syscall_64+0x6d/0x140
[  301.045967]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  301.046291] RIP: 0033:0x7fce6133ebcf
[  301.046520] RSP: 002b:00007ffc75dfc160 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
[  301.046927] RAX: ffffffffffffffda RBX: 00000000000000e0 RCX: 00007fce6133ebcf
[  301.047334] RDX: 00000000000000e0 RSI: 000055d58ad570a0 RDI: 0000000000000005
[  301.047749] RBP: 000055d58ad570a0 R08: 0000000000000000 R09: 00007fce613b14e0
[  301.048166] R10: 00007fce613b13e0 R11: 0000000000000293 R12: 00000000000000e0
[  301.048575] R13: 000055d58ad4d2a0 R14: 00000000000000e0 R15: 00007fce613f69e0
[  301.049042]  </TASK>
[  301.049214] INFO: task in:imjournal:334 blocked for more than 147 seconds.
[  301.049612]       Tainted: G        W          6.12.0-rc2-8cf0b93919e1 #1
[  301.050007] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  301.050439] task:in:imjournal    state:D stack:0     pid:334   tgid:306   ppid:1      flags:0x00000002
[  301.050977] Call Trace:
[  301.051131]  <TASK>
[  301.051273]  __schedule+0xe13/0x33a0
[  301.051517]  ? __pfx___schedule+0x10/0x10
[  301.051759]  ? lock_release+0x441/0x870
[  301.052009]  ? __pfx_lock_release+0x10/0x10
[  301.052252]  ? trace_lock_acquire+0x139/0x1b0
[  301.052517]  ? lock_acquire+0x80/0xb0
[  301.052769]  ? schedule+0x216/0x3f0
[  301.052989]  schedule+0xf6/0x3f0
[  301.053194]  io_schedule+0xce/0x150
[  301.053423]  bit_wait_io+0x1f/0x100
[  301.053642]  __wait_on_bit+0x68/0x1b0
[  301.053876]  ? __pfx_bit_wait_io+0x10/0x10
[  301.054124]  out_of_line_wait_on_bit+0xe6/0x120
[  301.054690]  ? __pfx_out_of_line_wait_on_bit+0x10/0x10
[  301.055405]  ? __pfx_wake_bit_function+0x10/0x10
[  301.056042]  ? __might_sleep+0xa3/0x170
[  301.056568]  do_get_write_access+0x83b/0x1010
[  301.057268]  jbd2_journal_get_write_access+0x1e4/0x270
[  301.057984]  __ext4_journal_get_write_access+0x72/0x3b0
[  301.058635]  __ext4_new_inode+0xfef/0x5320
[  301.059016]  ? __pfx___ext4_new_inode+0x10/0x10
[  301.059410]  ? __pfx___dquot_initialize+0x10/0x10
[  301.059840]  ? _raw_spin_unlock+0x31/0x60
[  301.060186]  ? d_splice_alias+0x4e8/0xe30
[  301.060541]  ext4_create+0x32e/0x550
[  301.060926]  ? __pfx_ext4_create+0x10/0x10
[  301.061302]  ? inode_permission+0xf4/0x650
[  301.061656]  ? __sanitizer_cov_trace_const_cmp4+0x1a/0x20
[  301.062115]  ? __pfx_ext4_create+0x10/0x10
[  301.062477]  lookup_open.isra.0+0x117c/0x1580
[  301.062761]  ? __pfx_lookup_open.isra.0+0x10/0x10
[  301.063072]  ? lock_acquire+0x80/0xb0
[  301.063302]  ? path_openat+0xd40/0x2bf0
[  301.063555]  ? __sanitizer_cov_trace_const_cmp4+0x1a/0x20
[  301.063888]  path_openat+0xdbf/0x2bf0
[  301.064138]  ? __pfx_path_openat+0x10/0x10
[  301.064396]  ? __this_cpu_preempt_check+0x21/0x30
[  301.064719]  ? lock_is_held_type+0xef/0x150
[  301.064986]  ? __this_cpu_preempt_check+0x21/0x30
[  301.065281]  do_filp_open+0x1cc/0x420
[  301.065520]  ? __pfx_do_filp_open+0x10/0x10
[  301.065783]  ? lock_release+0x441/0x870
[  301.066045]  ? do_raw_spin_unlock+0x15c/0x210
[  301.066339]  do_sys_openat2+0x185/0x1f0
[  301.066574]  ? __pfx_do_sys_openat2+0x10/0x10
[  301.066835]  ? __this_cpu_preempt_check+0x21/0x30
[  301.067117]  ? seqcount_lockdep_reader_access.constprop.0+0xb4/0xd0
[  301.067501]  ? lockdep_hardirqs_on+0x89/0x110
[  301.067770]  __x64_sys_openat+0x17a/0x240
[  301.068018]  ? __pfx___x64_sys_openat+0x10/0x10
[  301.068287]  ? __audit_syscall_entry+0x39c/0x500
[  301.068569]  x64_sys_call+0x1a52/0x20d0
[  301.068835]  do_syscall_64+0x6d/0x140
[  301.069041]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  301.069312] RIP: 0033:0x7facd0d3e8c4
[  301.069536] RSP: 002b:00007faccfdfea40 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
[  301.069982] RAX: ffffffffffffffda RBX: 00007facc8000c10 RCX: 00007facd0d3e8c4
[  301.070401] RDX: 0000000000000241 RSI: 00007faccfdfeb80 RDI: 00000000ffffff9c
[  301.070826] RBP: 00007faccfdfeb80 R08: 0000000000000000 R09: 0000000000000001
[  301.071247] R10: 00000000000001b6 R11: 0000000000000293 R12: 0000000000000241
[  301.071660] R13: 00007facc8000c10 R14: 0000000000000001 R15: 00007facc800c6d0
[  301.072098]  </TASK>
[  301.072245] INFO: task rs:main Q:Reg:336 blocked for more than 147 seconds.
[  301.072644]       Tainted: G        W          6.12.0-rc2-8cf0b93919e1 #1
[  301.073072] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  301.073518] task:rs:main Q:Reg   state:D stack:0     pid:336   tgid:306   ppid:1      flags:0x00000002
[  301.074768] Call Trace:
[  301.075140]  <TASK>
[  301.075469]  __schedule+0xe13/0x33a0
[  301.076024]  ? __pfx___schedule+0x10/0x10
[  301.076587]  ? lock_release+0x441/0x870
[  301.077203]  ? __pfx_lock_release+0x10/0x10
[  301.077781]  ? trace_lock_acquire+0x139/0x1b0
[  301.078405]  ? lock_acquire+0x80/0xb0
[  301.078864]  ? schedule+0x216/0x3f0
[  301.079095]  schedule+0xf6/0x3f0
[  301.079307]  io_schedule+0xce/0x150
[  301.079520]  bit_wait_io+0x1f/0x100
[  301.079745]  __wait_on_bit+0x68/0x1b0
[  301.079978]  ? __pfx_bit_wait_io+0x10/0x10
[  301.080244]  out_of_line_wait_on_bit+0xe6/0x120
[  301.080531]  ? __pfx_out_of_line_wait_on_bit+0x10/0x10
[  301.080883]  ? __pfx_wake_bit_function+0x10/0x10
[  301.081175]  ? __might_sleep+0xa3/0x170
[  301.081417]  do_get_write_access+0x83b/0x1010
[  301.081712]  jbd2_journal_get_write_access+0x1e4/0x270
[  301.082029]  __ext4_journal_get_write_access+0x72/0x3b0
[  301.082354]  ext4_reserve_inode_write+0x199/0x280
[  301.082655]  ? ext4_dirty_inode+0xeb/0x140
[  301.082926]  __ext4_mark_inode_dirty+0x18b/0x8c0
[  301.083221]  ? debug_smp_processor_id+0x20/0x30
[  301.083498]  ? __pfx___ext4_mark_inode_dirty+0x10/0x10
[  301.083803]  ? trace_jbd2_handle_start+0x77/0x210
[  301.084097]  ? jbd2__journal_start+0xff/0x6b0
[  301.084378]  ? __ext4_journal_start_sb+0x1f8/0x600
[  301.084712]  ? ext4_dirty_inode+0xb3/0x140
[  301.084987]  ? __pfx_ext4_dirty_inode+0x10/0x10
[  301.085273]  ext4_dirty_inode+0xeb/0x140
[  301.085509]  ? rcu_is_watching+0x19/0xc0
[  301.085746]  __mark_inode_dirty+0x1d0/0xd50
[  301.086002]  ? __pfx_generic_write_checks+0x10/0x10
[  301.086292]  generic_update_time+0xe0/0x110
[  301.086549]  file_modified+0x1af/0x1e0
[  301.086795]  ext4_buffered_write_iter+0x101/0x3e0
[  301.087087]  ext4_file_write_iter+0x8b8/0x1ab0
[  301.087364]  ? __pfx_lock_acquire.part.0+0x10/0x10
[  301.087665]  ? debug_smp_processor_id+0x20/0x30
[  301.087958]  ? __pfx_ext4_file_write_iter+0x10/0x10
[  301.088238]  ? __this_cpu_preempt_check+0x21/0x30
[  301.088513]  ? lock_is_held_type+0xef/0x150
[  301.088812]  vfs_write+0xc46/0x1120
[  301.089046]  ? __pfx_ext4_file_write_iter+0x10/0x10
[  301.089348]  ? __pfx_vfs_write+0x10/0x10
[  301.089617]  ? mutex_lock_nested+0x1f/0x30
[  301.089890]  ksys_write+0x14f/0x290
[  301.090122]  ? __pfx_ksys_write+0x10/0x10
[  301.090386]  ? __audit_syscall_entry+0x39c/0x500
[  301.090681]  __x64_sys_write+0x7b/0xc0
[  301.090926]  ? syscall_trace_enter+0x14a/0x230
[  301.091216]  x64_sys_call+0x1685/0x20d0
[  301.091463]  do_syscall_64+0x6d/0x140
[  301.091701]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  301.092019] RIP: 0033:0x7facd0d3ebcf
[  301.092239] RSP: 002b:00007faccf7ff890 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
[  301.092709] RAX: ffffffffffffffda RBX: 00007facc0001330 RCX: 00007facd0d3ebcf
[  301.093117] RDX: 000000000000004e RSI: 00007facc0001610 RDI: 0000000000000007
[  301.093533] RBP: 00007facc0001610 R08: 0000000000000000 R09: 0000000000000000
[  301.093950] R10: 000000000000000b R11: 0000000000000293 R12: 0000000000000000
[  301.094372] R13: 0000558c28823330 R14: 00007facc0001330 R15: 000000000000004e
[  301.094812]  </TASK>
[  301.094999]
[  301.094999] Showing all locks held in the system:
[  301.095377] 4 locks held by kworker/u8:1/31:
[  301.095644]  #0: ffff88800e3fa948 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work+0x11fc/0x1b50
[  301.096211]  #1: ffff88800df8fd78 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work+0x8a0/0x1b0
[  301.096880]  #2: ffff8880120a80e0 (&type->s_umount_key#38){++++}-{3:3}, at: super_trylock_shared+0x2b/0x110
[  301.097481]  #3: ffff8880120c4b98 (&sbi->s_writepages_rwsem){++++}-{0:0}, at: do_writepages+0x1c3/0x8a0
[  301.098057] 1 lock held by khungtaskd/33:
[  301.098308]  #0: ffffffff8705c9c0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x73/0x3c0
[  301.098853] 4 locks held by kworker/u8:2/35:
[  301.099115]  #0: ffff88800e3fa948 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work+0x11fc/0x1b50
[  301.099689]  #1: ffff88800e4bfd78 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work+0x8a0/0x1b0
[  301.100309]  #2: ffff8880120a80e0 (&type->s_umount_key#38){++++}-{3:3}, at: super_trylock_shared+0x2b/0x110
[  301.100913]  #3: ffff8880120c4b98 (&sbi->s_writepages_rwsem){++++}-{0:0}, at: do_writepages+0x1c3/0x8a0
[  301.101483] 3 locks held by kworker/u8:3/52:
[  301.101731]  #0: ffff88800e3fa948 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work+0x11fc/0x1b50
[  301.102316]  #1: ffff88800ed7fd78 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work+0x8a0/0x1b0
[  301.102968]  #2: ffff88800d77e0e0 (&type->s_umount_key#52){.+.+}-{3:3}, at: super_trylock_shared+0x2b/0x110
[  301.103573] 4 locks held by kworker/1:3/159:
[  301.103836]  #0: ffff88800d45ad48 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x11fc/0x1b50
[  301.104387]  #1: ffff8880119a7d78 ((work_completion)(&(&ap->scsi_rescan_task)->work)){+.+.}-{0:0}, at: process_one_work0
[  301.105271]  #2: ffff88801008c430 (&ap->scsi_scan_mutex){+.+.}-{3:3}, at: ata_scsi_dev_rescan+0x42/0x470
[  301.106491]  #3: ffff888010882378 (&dev->mutex){....}-{3:3}, at: scsi_rescan_device+0x33/0x360
[  301.107610] 4 locks held by auditd/239:
[  301.108110]  #0: ffff88801395ed38 (&f->f_pos_lock){+.+.}-{3:3}, at: fdget_pos+0x25e/0x380
[  301.109316]  #1: ffff8880120a8408 (sb_writers#3){.+.+}-{0:0}, at: ksys_write+0x14f/0x290
[  301.110411]  #2: ffff888016365c90 (&sb->s_type->i_mutex_key#8){++++}-{3:3}, at: ext4_buffered_write_iter+0xb8/0x3e0
[  301.111040]  #3: ffff8880120c6958 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x107b/0x1590
[  301.111570] 3 locks held by in:imjournal/334:
[  301.111822]  #0: ffff8880120a8408 (sb_writers#3){.+.+}-{0:0}, at: path_openat+0x1f7c/0x2bf0
[  301.112326]  #1: ffff88801c26fa18 (&type->i_mutex_dir_key#3){++++}-{3:3}, at: path_openat+0xd40/0x2bf0
[  301.112915]  #2: ffff8880120c6958 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x107b/0x1590
[  301.113452] 4 locks held by rs:main Q:Reg/336:
[  301.113721]  #0: ffff888014ed50b8 (&f->f_pos_lock){+.+.}-{3:3}, at: fdget_pos+0x25e/0x380
[  301.114200]  #1: ffff8880120a8408 (sb_writers#3){.+.+}-{0:0}, at: ksys_write+0x14f/0x290
[  301.114680]  #2: ffff888019730dd0 (&sb->s_type->i_mutex_key#8){++++}-{3:3}, at: ext4_buffered_write_iter+0xb8/0x3e0
[  301.115286]  #3: ffff8880120c6958 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x107b/0x1590
[  301.115816]
[  301.115926] =============================================
"

I hope you find it useful.

Regards,
Yi Lai

---

If you don't need the following environment to reproduce the problem or if you
already have one reproduced environment, please ignore the following information.

