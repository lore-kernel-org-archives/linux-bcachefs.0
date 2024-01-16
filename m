Received: from mail-108-mta138.mxroute.com (mail-108-mta138.mxroute.com [136.175.108.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC871C698
	for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jan 2024 15:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="P+ARAYqC"
Received: from filter006.mxroute.com ([136.175.111.2] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta138.mxroute.com (ZoneMTA) with ESMTPSA id 18d12dc3b7e0003727.003
 for <linux-bcachefs@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Tue, 16 Jan 2024 15:20:39 +0000
X-Zone-Loop: 0645a08f6fb6aa1b468781f4e8fdf666a73aa5ca61b1
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:In-reply-to:Date:Subject:Cc:To:
	From:References:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xxsV19Cy5hmicCvMDYCooq3u3RkqLDvmQC/na1NXqeA=; b=P+ARAYqCbxh1unO96jWT0lCaWo
	HCmbBVGiYUskoCY0q5oamq/K1WvNFPw7g163wVpA92Itb+hpXX3965j+rO2cVvHEARRAQhzCJwPkT
	XPSKH+0VU+3nQun2082KswBKsihwvVoQPiK26BB9ahBeNkOF7yPSt+sEDD3JiXAoOYwgj0sahiZoq
	bWMC7f9T6KPiZ/m3y23WzXx3uXk4evfeRPT67ziu0CHyrE1TpmAqVWA05rDVwlstHgyl9m+ZoX2AJ
	wChN/BAsYU6QMyxV5YM4T3pS3ptly/97yGq6wO8UY/Xm/7kyAJLXDs4Nc0M4rHbs7Ld9dblPd3qAJ
	4lM8wO9g==;
References: <20240115022125.148669-1-glass.su@suse.com>
 <ZaaJBUlutcDw7s8D@bfoster>
User-agent: mu4e 1.7.5; emacs 28.2
From: Su Yue <l@damenly.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Su Yue <glass.su@suse.com>, linux-bcachefs@vger.kernel.org, l@damenly.org
Subject: Re: [PATCH] bcachefs: grab s_umount only if snapshotting
Date: Tue, 16 Jan 2024 22:10:53 +0800
In-reply-to: <ZaaJBUlutcDw7s8D@bfoster>
Message-ID: <8r4p71d3.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org


On Tue 16 Jan 2024 at 08:47, Brian Foster <bfoster@redhat.com> 
wrote:

> On Mon, Jan 15, 2024 at 10:21:25AM +0800, Su Yue wrote:
>> When I was testing mongodb over bcachefs with compression,
>> there is a lockdep warning when snapshotting mongodb data 
>> volume.
>>
>> $ cat test.sh
>> prog=bcachefs
>>
>> $prog subvolume create /mnt/data
>> $prog subvolume create /mnt/data/snapshots
>>
>> while true;do
>>     $prog subvolume snapshot /mnt/data 
>>     /mnt/data/snapshots/$(date +%s)
>>     sleep 1s
>> done
>>
>> $ cat /etc/mongodb.conf
>> systemLog:
>>   destination: file
>>   logAppend: true
>>   path: /mnt/data/mongod.log
>>
>> storage:
>>   dbPath: /mnt/data/
>>
>> lockdep reports:
>> [ 3437.452330] 
>> ======================================================
>> [ 3437.452750] WARNING: possible circular locking dependency 
>> detected
>> [ 3437.453168] 6.7.0-rc7-custom+ #85 Tainted: G            E
>> [ 3437.453562] 
>> ------------------------------------------------------
>> [ 3437.453981] bcachefs/35533 is trying to acquire lock:
>> [ 3437.454325] ffffa0a02b2b1418 (sb_writers#10){.+.+}-{0:0}, 
>> at: filename_create+0x62/0x190
>> [ 3437.454875]
>>                but task is already holding lock:
>> [ 3437.455268] ffffa0a02b2b10e0 
>> (&type->s_umount_key#48){.+.+}-{3:3}, at: 
>> bch2_fs_file_ioctl+0x232/0xc90 [bcachefs]
>> [ 3437.456009]
>>                which lock already depends on the new lock.
>>
>> [ 3437.456553]
>>                the existing dependency chain (in reverse order) 
>>                is:
>> [ 3437.457054]
>>                -> #3 (&type->s_umount_key#48){.+.+}-{3:3}:
>> [ 3437.457507]        down_read+0x3e/0x170
>> [ 3437.457772]        bch2_fs_file_ioctl+0x232/0xc90 [bcachefs]
>> [ 3437.458206]        __x64_sys_ioctl+0x93/0xd0
>> [ 3437.458498]        do_syscall_64+0x42/0xf0
>> [ 3437.458779]        entry_SYSCALL_64_after_hwframe+0x6e/0x76
>> [ 3437.459155]
>>                -> #2 (&c->snapshot_create_lock){++++}-{3:3}:
>> [ 3437.459615]        down_read+0x3e/0x170
>> [ 3437.459878]        bch2_truncate+0x82/0x110 [bcachefs]
>> [ 3437.460276]        bchfs_truncate+0x254/0x3c0 [bcachefs]
>> [ 3437.460686]        notify_change+0x1f1/0x4a0
>> [ 3437.461283]        do_truncate+0x7f/0xd0
>> [ 3437.461555]        path_openat+0xa57/0xce0
>> [ 3437.461836]        do_filp_open+0xb4/0x160
>> [ 3437.462116]        do_sys_openat2+0x91/0xc0
>> [ 3437.462402]        __x64_sys_openat+0x53/0xa0
>> [ 3437.462701]        do_syscall_64+0x42/0xf0
>> [ 3437.462982]        entry_SYSCALL_64_after_hwframe+0x6e/0x76
>> [ 3437.463359]
>>                -> #1 (&sb->s_type->i_mutex_key#15){+.+.}-{3:3}:
>> [ 3437.463843]        down_write+0x3b/0xc0
>> [ 3437.464223]        bch2_write_iter+0x5b/0xcc0 [bcachefs]
>> [ 3437.464493]        vfs_write+0x21b/0x4c0
>> [ 3437.464653]        ksys_write+0x69/0xf0
>> [ 3437.464839]        do_syscall_64+0x42/0xf0
>> [ 3437.465009]        entry_SYSCALL_64_after_hwframe+0x6e/0x76
>> [ 3437.465231]
>>                -> #0 (sb_writers#10){.+.+}-{0:0}:
>> [ 3437.465471]        __lock_acquire+0x1455/0x21b0
>> [ 3437.465656]        lock_acquire+0xc6/0x2b0
>> [ 3437.465822]        mnt_want_write+0x46/0x1a0
>> [ 3437.465996]        filename_create+0x62/0x190
>> [ 3437.466175]        user_path_create+0x2d/0x50
>> [ 3437.466352]        bch2_fs_file_ioctl+0x2ec/0xc90 [bcachefs]
>> [ 3437.466617]        __x64_sys_ioctl+0x93/0xd0
>> [ 3437.466791]        do_syscall_64+0x42/0xf0
>> [ 3437.466957]        entry_SYSCALL_64_after_hwframe+0x6e/0x76
>> [ 3437.467180]
>>                other info that might help us debug this:
>>
>> [ 3437.469670] 2 locks held by bcachefs/35533:
>>                other info that might help us debug this:
>>
>> [ 3437.467507] Chain exists of:
>>                  sb_writers#10 --> &c->snapshot_create_lock --> 
>>                  &type->s_umount_key#48
>>
>> [ 3437.467979]  Possible unsafe locking scenario:
>>
>> [ 3437.468223]        CPU0                    CPU1
>> [ 3437.468405]        ----                    ----
>> [ 3437.468585]   rlock(&type->s_umount_key#48);
>> [ 3437.468758] 
>> lock(&c->snapshot_create_lock);
>> [ 3437.469030] 
>> lock(&type->s_umount_key#48);
>> [ 3437.469291]   rlock(sb_writers#10);
>> [ 3437.469434]
>>                 *** DEADLOCK ***
>>
>> [ 3437.469670] 2 locks held by bcachefs/35533:
>> [ 3437.469838]  #0: ffffa0a02ce00a88 
>> (&c->snapshot_create_lock){++++}-{3:3}, at: 
>> bch2_fs_file_ioctl+0x1e3/0xc90 [bcachefs]
>> [ 3437.470294]  #1: ffffa0a02b2b10e0 
>> (&type->s_umount_key#48){.+.+}-{3:3}, at: 
>> bch2_fs_file_ioctl+0x232/0xc90 [bcachefs]
>> [ 3437.470744]
>>                stack backtrace:
>> [ 3437.470922] CPU: 7 PID: 35533 Comm: bcachefs Kdump: loaded 
>> Tainted: G            E      6.7.0-rc7-custom+ #85
>> [ 3437.471313] Hardware name: QEMU Standard PC (i440FX + PIIX, 
>> 1996), BIOS Arch Linux 1.16.3-1-1 04/01/2014
>> [ 3437.471694] Call Trace:
>> [ 3437.471795]  <TASK>
>> [ 3437.471884]  dump_stack_lvl+0x57/0x90
>> [ 3437.472035]  check_noncircular+0x132/0x150
>> [ 3437.472202]  __lock_acquire+0x1455/0x21b0
>> [ 3437.472369]  lock_acquire+0xc6/0x2b0
>> [ 3437.472518]  ? filename_create+0x62/0x190
>> [ 3437.472683]  ? lock_is_held_type+0x97/0x110
>> [ 3437.472856]  mnt_want_write+0x46/0x1a0
>> [ 3437.473025]  ? filename_create+0x62/0x190
>> [ 3437.473204]  filename_create+0x62/0x190
>> [ 3437.473380]  user_path_create+0x2d/0x50
>> [ 3437.473555]  bch2_fs_file_ioctl+0x2ec/0xc90 [bcachefs]
>> [ 3437.473819]  ? lock_acquire+0xc6/0x2b0
>> [ 3437.474002]  ? __fget_files+0x2a/0x190
>> [ 3437.474195]  ? __fget_files+0xbc/0x190
>> [ 3437.474380]  ? lock_release+0xc5/0x270
>> [ 3437.474567]  ? __x64_sys_ioctl+0x93/0xd0
>> [ 3437.474764]  ? __pfx_bch2_fs_file_ioctl+0x10/0x10 [bcachefs]
>> [ 3437.475090]  __x64_sys_ioctl+0x93/0xd0
>> [ 3437.475277]  do_syscall_64+0x42/0xf0
>> [ 3437.475454]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
>> [ 3437.475691] RIP: 0033:0x7f2743c313af
>> ======================================================
>>
>> In __bch2_ioctl_subvolume_create(), we grab s_umount 
>> unconditionally
>> and unlock it at the end of the function. There is a comment
>> "why do we need this lock?" about the lock coming from
>> commit 42d237320e98 ("bcachefs: Snapshot creation, deletion")
>> The reason is that __bch2_ioctl_subvolume_create() calls
>> sync_inodes_sb() which enforce locked s_umount to writeback all 
>> dirty
>> nodes before doing snapshot works.
>>
>> Fix it by read locking s_umount for snapshotting only and 
>> unlocking
>> s_umount after sync_inodes_sb().
>>
>
> Heh, seems reasonable to me..
>
>> Signed-off-by: Su Yue <glass.su@suse.com>
>> ---
>>  fs/bcachefs/fs-ioctl.c | 11 +++++------
>>  1 file changed, 5 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
>> index e0a19a73c8e1..1346861ed944 100644
>> --- a/fs/bcachefs/fs-ioctl.c
>> +++ b/fs/bcachefs/fs-ioctl.c
>> @@ -337,11 +337,12 @@ static long 
>> __bch2_ioctl_subvolume_create(struct bch_fs *c, struct file 
>> *filp,
>>  	if (arg.flags & BCH_SUBVOL_SNAPSHOT_RO)
>>  		create_flags |= BCH_CREATE_SNAPSHOT_RO;
>>
>> -	/* why do we need this lock? */
>> -	down_read(&c->vfs_sb->s_umount);
>> -
>> -	if (arg.flags & BCH_SUBVOL_SNAPSHOT_CREATE)
>> +	if (arg.flags & BCH_SUBVOL_SNAPSHOT_CREATE) {
>> +		/* sync_inodes_sb enforce s_umount is locked */
>> +		down_read(&c->vfs_sb->s_umount);
>>  		sync_inodes_sb(c->vfs_sb);
>> +		up_read(&c->vfs_sb->s_umount);
>> +	}
>>  retry:
>>  	if (arg.src_ptr) {
>>  		error = user_path_at(arg.dirfd,
>> @@ -425,8 +426,6 @@ static long 
>> __bch2_ioctl_subvolume_create(struct bch_fs *c, struct file 
>> *filp,
>>  		goto retry;
>>  	}
>>  err1:
>> -	up_read(&c->vfs_sb->s_umount);
>> -
>
> Can we get rid of this label now that it serves no purpose?
>
I think we can't. Two gotos are still there(under the retry label)
unless change them to return

--
Su

> Brian
>
>>  	return error;
>>  }
>>
>> --
>> 2.43.0
>>
>>
