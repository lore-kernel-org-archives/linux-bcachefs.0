Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C9F20E310
	for <linux-bcachefs@vger.kernel.org>; Wed, 12 Feb 2025 17:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739382109; cv=none; b=ksOQeVTMsgFsYli7I3eowPe5WoHcnjwMLs+3q5fXD1wDOEE3Am4n02B2WP8zPXTYDNi8eZO3Cdc8j2vfK5XlkKJWcoTrVmFDZisPvcU6Or3IFSlbCZUzlvE6gIZHAcV3A9LswUf2e0/r60HDEleLFvBsAveIemSyCONZrK37Zt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739382109; c=relaxed/simple;
	bh=ADAfuXGzDoUrazL10f/J+NYMQlnKEVAdzWlMJtylq+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cB4HtIlCCoy7l5j63nQLqxKTIXfd3AurSzEbHjr8KeVQxnro/7Ar/sflYSrbMrDWE4xUtsmnnRaGkFkXJ0yjnhDn9d2+c4+JyC7FzKbyXUlvFsQcNwxGrtcKplNEh7zWmhKGikmjLLx8mOk9NifW0HJAEpxb0fhTWGjjXK4pgXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gyu/8Q+q; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gyu/8Q+q"
Date: Wed, 12 Feb 2025 12:41:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739382101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qEJjrw91ROJtMwFAuiXGhmAm8t6hmiNDk/AnLr+pJBA=;
	b=gyu/8Q+qu+ORcK+1q3VQEQVNCKXqgkbmJDwJ4/+9dkCO3IA/gfzs80Rj+tqDIYeM/sh7gQ
	WdNxs2/ernlUZ+eB8DWTXgPf0DJggPICThmtITlE8cOqA8S5KqvLZWDsfNRkxxMoZnA9qk
	H81QZwDeHusc0aprElwVB9NrC3hVX4U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2] bcachefs: Reuse transaction
Message-ID: <wgrudqrambpk4uyqg6wd3ziu3dkufv3jmh77vpkrfbkjwdxumq@o3vc7xdku5xt>
References: <20250212172916.137891-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250212172916.137891-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 13, 2025 at 01:29:16AM +0800, Alan Huang wrote:
> bch2_nocow_write_convert_unwritten is already in transaction context:
> 
> 00191 ========= TEST   generic/648
> 00242 kernel BUG at fs/bcachefs/btree_iter.c:3332!
> 00242 Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
> 00242 Modules linked in:
> 00242 CPU: 4 UID: 0 PID: 2593 Comm: fsstress Not tainted 6.13.0-rc3-ktest-g345af8f855b7 #14403
> 00242 Hardware name: linux,dummy-virt (DT)
> 00242 pstate: 60001005 (nZCv daif -PAN -UAO -TCO -DIT +SSBS BTYPE=--)
> 00242 pc : __bch2_trans_get+0x120/0x410
> 00242 lr : __bch2_trans_get+0xcc/0x410
> 00242 sp : ffffff80d89af600
> 00242 x29: ffffff80d89af600 x28: ffffff80ddb23000 x27: 00000000fffff705
> 00242 x26: ffffff80ddb23028 x25: ffffff80d8903fe0 x24: ffffff80ebb30168
> 00242 x23: ffffff80c8aeb500 x22: 000000000000005d x21: ffffff80d8904078
> 00242 x20: ffffff80d8900000 x19: ffffff80da9e8000 x18: 0000000000000000
> 00242 x17: 64747568735f6c61 x16: 6e72756f6a20726f x15: 0000000000000028
> 00242 x14: 0000000000000004 x13: 000000000000f787 x12: ffffffc081bbcdc8
> 00242 x11: 0000000000000000 x10: 0000000000000003 x9 : ffffffc08094efbc
> 00242 x8 : 000000001092c111 x7 : 000000000000000c x6 : ffffffc083c31fc4
> 00242 x5 : ffffffc083c31f28 x4 : ffffff80c8aeb500 x3 : ffffff80ebb30000
> 00242 x2 : 0000000000000001 x1 : 0000000000000a21 x0 : 000000000000028e
> 00242 Call trace:
> 00242  __bch2_trans_get+0x120/0x410 (P)
> 00242  bch2_inum_offset_err_msg+0x48/0xb0
> 00242  bch2_nocow_write_convert_unwritten+0x3d0/0x530
> 00242  bch2_nocow_write+0xeb0/0x1000
> 00242  __bch2_write+0x330/0x4e8
> 00242  bch2_write+0x1f0/0x530
> 00242  bch2_direct_write+0x530/0xc00
> 00242  bch2_write_iter+0x160/0xbe0
> 00242  vfs_write+0x1cc/0x360
> 00242  ksys_write+0x5c/0xf0
> 00242  __arm64_sys_write+0x20/0x30
> 00242  invoke_syscall.constprop.0+0x54/0xe8
> 00242  do_el0_svc+0x44/0xc0
> 00242  el0_svc+0x34/0xa0
> 00242  el0t_64_sync_handler+0x104/0x130
> 00242  el0t_64_sync+0x154/0x158
> 00242 Code: 6b01001f 54ffff01 79408460 3617fec0 (d4210000)
> 00242 ---[ end trace 0000000000000000 ]---
> 00242 Kernel panic - not syncing: Oops - BUG: Fatal exception
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Applied

> ---
>  fs/bcachefs/io_write.c | 33 +++++++++++++++++++++++++++++++--
>  fs/bcachefs/io_write.h |  4 ++++
>  2 files changed, 35 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
> index 0d4a7e58251a..738bdbfbdb14 100644
> --- a/fs/bcachefs/io_write.c
> +++ b/fs/bcachefs/io_write.c
> @@ -396,6 +396,35 @@ static int bch2_write_index_default(struct bch_write_op *op)
>  
>  /* Writes */
>  
> +void bch2_write_op_error_trans(struct btree_trans *trans, struct printbuf *out,
> +			       struct bch_write_op *op, u64 offset, const char *fmt, ...)
> +{
> +	if (op->subvol)
> +		lockrestart_do(trans,
> +			bch2_inum_offset_err_msg_trans(trans, out,
> +						       (subvol_inum) { op->subvol, op->pos.inode, },
> +						       offset << 9));
> +	else {
> +		struct bpos pos = op->pos;
> +		pos.offset = offset;
> +		lockrestart_do(trans, bch2_inum_snap_offset_err_msg_trans(trans, out, pos));
> +	}
> +
> +	prt_str(out, "write error: ");
> +
> +	va_list args;
> +	va_start(args, fmt);
> +	prt_vprintf(out, fmt, args);
> +	va_end(args);
> +
> +	if (op->flags & BCH_WRITE_move) {
> +		struct data_update *u = container_of(op, struct data_update, op);
> +
> +		prt_printf(out, "\n  from internal move ");
> +		bch2_bkey_val_to_text(out, op->c, bkey_i_to_s_c(u->k.k));
> +	}
> +}
> +
>  void bch2_write_op_error(struct printbuf *out, struct bch_write_op *op, u64 offset,
>  			 const char *fmt, ...)
>  {
> @@ -1214,8 +1243,8 @@ static void bch2_nocow_write_convert_unwritten(struct bch_write_op *op)
>  			struct bkey_i *insert = bch2_keylist_front(&op->insert_keys);
>  
>  			struct printbuf buf = PRINTBUF;
> -			bch2_write_op_error(&buf, op, bkey_start_offset(&insert->k),
> -					    "btree update error: %s", bch2_err_str(ret));
> +			bch2_write_op_error_trans(trans, &buf, op, bkey_start_offset(&insert->k),
> +						  "btree update error: %s", bch2_err_str(ret));
>  			bch_err_ratelimited(c, "%s", buf.buf);
>  			printbuf_exit(&buf);
>  		}
> diff --git a/fs/bcachefs/io_write.h b/fs/bcachefs/io_write.h
> index 2d12ffb94736..bf942566a8eb 100644
> --- a/fs/bcachefs/io_write.h
> +++ b/fs/bcachefs/io_write.h
> @@ -20,6 +20,10 @@ static inline void bch2_latency_acct(struct bch_dev *ca, u64 submit_time, int rw
>  void bch2_submit_wbio_replicas(struct bch_write_bio *, struct bch_fs *,
>  			       enum bch_data_type, const struct bkey_i *, bool);
>  
> +__printf(5, 6)
> +void bch2_write_op_error_trans(struct btree_trans *trans, struct printbuf *out,
> +			       struct bch_write_op *op, u64, const char *, ...);
> +
>  __printf(4, 5)
>  void bch2_write_op_error(struct printbuf *out, struct bch_write_op *op, u64,
>  			 const char *, ...);
> -- 
> 2.47.0
> 
