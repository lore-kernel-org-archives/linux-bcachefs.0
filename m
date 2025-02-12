Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691001A5AA
	for <linux-bcachefs@vger.kernel.org>; Wed, 12 Feb 2025 14:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739369950; cv=none; b=CUqZrPTB72f8h3/qvGAakWw+anizXVW7K1X9QfE+mI4C45p+mqxYu1SV3iGebvyeyoiWoFo6i7DX80bglftIJAVvfprbk8WfwWNiCz8q8F0hlewuH8TCezYpDWsStoRYjIt88s/vqOJtjelq1cEPaielb6/yfC6Wm7ov9luwBvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739369950; c=relaxed/simple;
	bh=uyGd6/D9mJeHQ+pAJKZevj2tIEshNTuIq3Wmsd44Cas=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AAeKL59T2eknGEG+ylcR58CsmkCFhtEN3llVixwci/TRTPfQ4WtKfkFejykViIm1ItMun6acRw6f9qmlVTpAtx0MDglknSzDVsw26lry/Iz9ERHXOE3WL8hLS/MXbUEZhII9U6lIzMYhcWxI4egfHKQLCrqjNB2mSeCLQ2KzAXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H6y4aZaY; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H6y4aZaY"
Date: Wed, 12 Feb 2025 09:18:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739369943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0QfK2Q4Lxexujsq8zBHWhYKChoxlOvyBZD1onXG96eE=;
	b=H6y4aZaYZ9geoagFw1oRNryN4lyo+BFjZyzBNfN7Un1UkeHSqx0K8qw/aMcUHmcWz5Ww6P
	NgEOtS/Bmu4bevG2aRde26ZrSi+K1xBvjHQxUVNp+ZfpUuuID4cGDXti9aQwEuFlCDsiuh
	D0kEFK1Qg9HwYctwfYUYkgYk166yFDY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Reuse transaction
Message-ID: <sr3gribt7igh7j6g35kmf3n6npefhc2k3joapkgqiob3wm74bv@3jxrhito5arv>
References: <20250212092751.52241-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250212092751.52241-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 12, 2025 at 05:27:51PM +0800, Alan Huang wrote:
> bch2_nocow_write_convert_unwritten is already in transaction context:

Can you rebase?

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
> ---
>  fs/bcachefs/io_write.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
> index d363a6e730a2..16618bbc46ce 100644
> --- a/fs/bcachefs/io_write.c
> +++ b/fs/bcachefs/io_write.c
> @@ -406,6 +406,16 @@ static void __bch2_write_op_error(struct printbuf *out, struct bch_write_op *op,
>  		   op->flags & BCH_WRITE_move ? "(internal move)" : "");
>  }
>  
> +static void bch2_write_op_error_trans(struct btree_trans *trans, struct printbuf *out,
> +				      struct bch_write_op *op, u64 offset)
> +{
> +	bch2_inum_offset_err_msg_trans(trans, out,
> +				       (subvol_inum) { op->subvol, op->pos.inode, },
> +				       offset << 9);
> +	prt_printf(out, "write error%s: ",
> +		   op->flags & BCH_WRITE_move ? "(internal move)" : "");
> +}
> +
>  static void bch2_write_op_error(struct printbuf *out, struct bch_write_op *op)
>  {
>  	__bch2_write_op_error(out, op, op->pos.offset);
> @@ -1193,7 +1203,7 @@ static void bch2_nocow_write_convert_unwritten(struct bch_write_op *op)
>  			struct bkey_i *insert = bch2_keylist_front(&op->insert_keys);
>  
>  			struct printbuf buf = PRINTBUF;
> -			__bch2_write_op_error(&buf, op, bkey_start_offset(&insert->k));
> +			bch2_write_op_error_trans(trans, &buf, op, bkey_start_offset(&insert->k));
>  			prt_printf(&buf, "btree update error: %s", bch2_err_str(ret));
>  			bch_err_ratelimited(c, "%s", buf.buf);
>  			printbuf_exit(&buf);
> -- 
> 2.47.0
> 
