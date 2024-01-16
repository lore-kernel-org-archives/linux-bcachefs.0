Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B241BC47
	for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jan 2024 13:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UTqarTTe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705413032;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HUjl0MwInjaGruhRglOeKdkS3QEEIWTxiFXApsKYRo0=;
	b=UTqarTTefiNxetMNDEvGa8Wjczma6HUDW1oy61yHDVWOtpLx/cBkqHAnIRZO+sePxQs9xX
	w70o88flbD9gszD63ICa9FNNZ4CfwNwF/yJskRlZ/jNIIa5csIyAEHVGeTUO/bE0Opl0Ho
	FdEGDvZrJhO3cGYWvOtudNqQEzzlwk0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-588-iZiCb2ybP6SlaqoZuztoaA-1; Tue,
 16 Jan 2024 08:50:30 -0500
X-MC-Unique: iZiCb2ybP6SlaqoZuztoaA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B2AA280BC8B;
	Tue, 16 Jan 2024 13:50:30 +0000 (UTC)
Received: from bfoster (unknown [10.22.8.116])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D18B0C15E75;
	Tue, 16 Jan 2024 13:50:29 +0000 (UTC)
Date: Tue, 16 Jan 2024 08:51:48 -0500
From: Brian Foster <bfoster@redhat.com>
To: Su Yue <glass.su@suse.com>
Cc: linux-bcachefs@vger.kernel.org, l@damenly.org
Subject: Re: [PATCH] bcachefs: kvfree bch_fs::snapshots in
 bch2_fs_snapshots_exit
Message-ID: <ZaaJ9H1e6ZctI2VH@bfoster>
References: <20240116110537.1124476-1-glass.su@suse.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240116110537.1124476-1-glass.su@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

On Tue, Jan 16, 2024 at 07:05:37PM +0800, Su Yue wrote:
> bch_fs::snapshots is allocated by kvzalloc in __snapshot_t_mut.
> It should be freed by kvfree not kfree.
> Or umount will triger:
> 
> [  406.829178 ] BUG: unable to handle page fault for address: ffffe7b487148008
> [  406.830676 ] #PF: supervisor read access in kernel mode
> [  406.831643 ] #PF: error_code(0x0000) - not-present page
> [  406.832487 ] PGD 0 P4D 0
> [  406.832898 ] Oops: 0000 [#1] PREEMPT SMP PTI
> [  406.833512 ] CPU: 2 PID: 1754 Comm: umount Kdump: loaded Tainted: G           OE      6.7.0-rc7-custom+ #90
> [  406.834746 ] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux 1.16.3-1-1 04/01/2014
> [  406.835796 ] RIP: 0010:kfree+0x62/0x140
> [  406.836197 ] Code: 80 48 01 d8 0f 82 e9 00 00 00 48 c7 c2 00 00 00 80 48 2b 15 78 9f 1f 01 48 01 d0 48 c1 e8 0c 48 c1 e0 06 48 03 05 56 9f 1f 01 <48> 8b 50 08 48 89 c7 f6 c2 01 0f 85 b0 00 00 00 66 90 48 8b 07 f6
> [  406.837810 ] RSP: 0018:ffffb9d641607e48 EFLAGS: 00010286
> [  406.838213 ] RAX: ffffe7b487148000 RBX: ffffb9d645200000 RCX: ffffb9d641607dc4
> [  406.838738 ] RDX: 000065bb00000000 RSI: ffffffffc0d88b84 RDI: ffffb9d645200000
> [  406.839217 ] RBP: ffff9a4625d00068 R08: 0000000000000001 R09: 0000000000000001
> [  406.839650 ] R10: 0000000000000001 R11: 000000000000001f R12: ffff9a4625d4da80
> [  406.840055 ] R13: ffff9a4625d00000 R14: ffffffffc0e2eb20 R15: 0000000000000000
> [  406.840451 ] FS:  00007f0a264ffb80(0000) GS:ffff9a4e2d500000(0000) knlGS:0000000000000000
> [  406.840851 ] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  406.841125 ] CR2: ffffe7b487148008 CR3: 000000018c4d2000 CR4: 00000000000006f0
> [  406.841464 ] Call Trace:
> [  406.841583 ]  <TASK>
> [  406.841682 ]  ? __die+0x1f/0x70
> [  406.841828 ]  ? page_fault_oops+0x159/0x470
> [  406.842014 ]  ? fixup_exception+0x22/0x310
> [  406.842198 ]  ? exc_page_fault+0x1ed/0x200
> [  406.842382 ]  ? asm_exc_page_fault+0x22/0x30
> [  406.842574 ]  ? bch2_fs_release+0x54/0x280 [bcachefs]
> [  406.842842 ]  ? kfree+0x62/0x140
> [  406.842988 ]  ? kfree+0x104/0x140
> [  406.843138 ]  bch2_fs_release+0x54/0x280 [bcachefs]
> [  406.843390 ]  kobject_put+0xb7/0x170
> [  406.843552 ]  deactivate_locked_super+0x2f/0xa0
> [  406.843756 ]  cleanup_mnt+0xba/0x150
> [  406.843917 ]  task_work_run+0x59/0xa0
> [  406.844083 ]  exit_to_user_mode_prepare+0x197/0x1a0
> [  406.844302 ]  syscall_exit_to_user_mode+0x16/0x40
> [  406.844510 ]  do_syscall_64+0x4e/0xf0
> [  406.844675 ]  entry_SYSCALL_64_after_hwframe+0x6e/0x76
> [  406.844907 ] RIP: 0033:0x7f0a2664e4fb
> 
> Signed-off-by: Su Yue <glass.su@suse.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/bcachefs/snapshot.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
> index 56af937523ff..cdcff4e5ae5c 100644
> --- a/fs/bcachefs/snapshot.c
> +++ b/fs/bcachefs/snapshot.c
> @@ -1681,5 +1681,5 @@ int bch2_snapshots_read(struct bch_fs *c)
>  
>  void bch2_fs_snapshots_exit(struct bch_fs *c)
>  {
> -	kfree(rcu_dereference_protected(c->snapshots, true));
> +	kvfree(rcu_dereference_protected(c->snapshots, true));
>  }
> -- 
> 2.43.0
> 
> 

