Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2672BEFF3
	for <linux-bcachefs@vger.kernel.org>; Tue,  2 Sep 2025 00:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756772060; cv=none; b=t+Ui/deDXAWAYlmpM2mUKHJ2aMDKwj+uZftfNb/jJfkxVA4z1JFJc8yT3C+6b6BIfhrIfyCAGXylduzizrYzjxuht/P7BEw+Unf30rwyswIh+xVZgGlmlRbpEPHNYkAnYNcAUz2w4SLY8y66TtvXt3FNsgjsgxLuubbrC5qEdMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756772060; c=relaxed/simple;
	bh=04GVRUelaeEYgEU/wfFrmeRBpz3sfF9WPGiXGr87bgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=srYQK4+3KZE0VWwxCWStqb+Dq0P/3mRI9QftlDnruIc4JYdiTpVhRTw+CFE87HsWVN0cxOIjjr+SftNltLSoRb/eJB2ya0ZD0tHWj62hNfRQf1JNVPsPd4Zo3S5MeY5XIQpXuOylr/DbPofa5KcFLIy0EmF5teXi5Ps6BhB9dhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MdS8ISg8; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MdS8ISg8"
Date: Mon, 1 Sep 2025 20:14:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756772055;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TqrmL9t+Rpu75mCuSfjD9DqRM/nKGcwa7E/5e/3+i4s=;
	b=MdS8ISg8iDEbIhzX0jlivw3nDNOjIBH9lHHUEyV5vmqnXZEjC93Tjt1AP98cdD9wy0TcJI
	Y5ifL2DXKKpC0uVH9tTp76yg7N9sn9SC0MQddCccEOjQh59H2VXGD8ZUcX0hopk9OoEaPR
	fI724xT3dRPfKuJ0CW92sv/pmy/w+zM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: himikof@gmail.com
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 09/15] bcachefs: Fix online hidden (sb+journal) data
 accounting
Message-ID: <nq27yraieyxddkoqd2bewilvfxe6jh2at44cflc3zxsu4k2pg3@eusye2bk6chp>
References: <20250828-better-progress-v2-0-c088a2003940@gmail.com>
 <20250828-better-progress-v2-9-c088a2003940@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828-better-progress-v2-9-c088a2003940@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 28, 2025 at 05:16:11PM +0300, Nikita Ofitserov via B4 Relay wrote:
> From: Nikita Ofitserov <himikof@gmail.com>
> 
> Now the c->usage->hidden counters are kept up to date by the same
> trigger-based mechanism as the other ones.

This pops warnings in accounting_verify_clean()

00133 ------------[ cut here ]------------
00133 WARNING: CPU: 8 PID: 595 at fs/bcachefs/disk_accounting.c:1144 bch2_verify_accounting_clean+0x8fc/0xac0
00133 Modules linked in:
00133 CPU: 8 UID: 0 PID: 595 Comm: mount.bcachefs Not tainted 6.17.0-rc3-ktest-g92dce30a5a04 #32156 NONE
00133 Hardware name: linux,dummy-virt (DT)
00133 pstate: 60001005 (nZCv daif -PAN -UAO -TCO -DIT +SSBS BTYPE=--)
00133 pc : bch2_verify_accounting_clean+0x8fc/0xac0
00133 lr : bch2_verify_accounting_clean+0xa60/0xac0
00133 sp : ffffffc081e0b9d0
00133 x29: ffffffc081e0bbe0 x28: ffffffc081e0ba70 x27: ffffffc080e59fc0
00133 x26: 0000000000000008 x25: 0000000000000003 x24: 0000000000000000
00133 x23: ffffff80e6220000 x22: ffffffc081e0bb08 x21: 0000000000000046
00133 x20: 0000000000000000 x19: ffffff80e4540000 x18: 00000000ffffffff
00133 x17: 696d206e65646469 x16: 682e657361625f65 x15: 676173755f736620
00133 x14: 29286e61656c635f x13: 0000000000000000 x12: ffffff80fadeffa8
00133 x11: ffffff80f97f0000 x10: ffffff80fadf0000 x9 : ffffffc0800a86f0
00133 x8 : 0000000000000001 x7 : 00000000005fffe8 x6 : 0000000000000001
00133 x5 : ffffff80fbcf9c90 x4 : 0000000000000000 x3 : 0000000000000000
00133 x2 : 0000000000000000 x1 : ffffff80c1576000 x0 : 0000000000000001
00133 Call trace:
00133  bch2_verify_accounting_clean+0x8fc/0xac0 (P)
00133  bch2_fs_read_only+0x2ec/0x358
00133  bch2_fs_reconfigure+0x98/0x128
00133  reconfigure_super+0x98/0x200
00133  path_mount+0x840/0xab8
00133  __arm64_sys_mount+0x160/0x2c0
00133  invoke_syscall.constprop.0+0x54/0xe0
00133  do_el0_svc+0x44/0xe0
00133  el0_svc+0x18/0x58
00133  el0t_64_sync_handler+0x98/0xe0
00133  el0t_64_sync+0x154/0x158
00133 ---[ end trace 0000000000000000 ]---

> 
> Signed-off-by: Nikita Ofitserov <himikof@gmail.com>
> ---
>  fs/bcachefs/disk_accounting.c | 12 ++++++++----
>  fs/bcachefs/disk_accounting.h | 10 +++++++---
>  2 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
> index 82ce610a7e40c86d84296a47ef7ea7b5eb82f816..1649c0e1a89e8f4f04d122e40553b36f11491df5 100644
> --- a/fs/bcachefs/disk_accounting.c
> +++ b/fs/bcachefs/disk_accounting.c
> @@ -1082,13 +1082,17 @@ void bch2_verify_accounting_clean(struct bch_fs *c)
>  		case BCH_DISK_ACCOUNTING_dev_data_type: {
>  			{
>  				guard(rcu)(); /* scoped guard is a loop, and doesn't play nicely with continue */
> +				const enum bch_data_type data_type = acc_k.dev_data_type.data_type;
>  				struct bch_dev *ca = bch2_dev_rcu_noerror(c, acc_k.dev_data_type.dev);
>  				if (!ca)
>  					continue;
>  
> -				v[0] = percpu_u64_get(&ca->usage->d[acc_k.dev_data_type.data_type].buckets);
> -				v[1] = percpu_u64_get(&ca->usage->d[acc_k.dev_data_type.data_type].sectors);
> -				v[2] = percpu_u64_get(&ca->usage->d[acc_k.dev_data_type.data_type].fragmented);
> +				v[0] = percpu_u64_get(&ca->usage->d[data_type].buckets);
> +				v[1] = percpu_u64_get(&ca->usage->d[data_type].sectors);
> +				v[2] = percpu_u64_get(&ca->usage->d[data_type].fragmented);
> +
> +				if (data_type == BCH_DATA_sb || data_type == BCH_DATA_journal)
> +					base.hidden += a.v->d[0] * ca->mi.bucket_size;
>  			}
>  
>  			if (memcmp(a.v->d, v, 3 * sizeof(u64))) {
> @@ -1116,7 +1120,7 @@ void bch2_verify_accounting_clean(struct bch_fs *c)
>  		mismatch = true;								\
>  	}
>  
> -	//check(hidden);
> +	check(hidden);
>  	check(btree);
>  	check(data);
>  	check(cached);
> diff --git a/fs/bcachefs/disk_accounting.h b/fs/bcachefs/disk_accounting.h
> index 438628b63a8065e22ec76aebcd69e285f84f41ef..c3f2dc5d0c14241f3c0ae2d367d6da504df2e1ab 100644
> --- a/fs/bcachefs/disk_accounting.h
> +++ b/fs/bcachefs/disk_accounting.h
> @@ -186,11 +186,15 @@ static inline int bch2_accounting_mem_mod_locked(struct btree_trans *trans,
>  			break;
>  		case BCH_DISK_ACCOUNTING_dev_data_type: {
>  			guard(rcu)();
> +			const enum bch_data_type data_type = acc_k.dev_data_type.data_type;
>  			struct bch_dev *ca = bch2_dev_rcu_noerror(c, acc_k.dev_data_type.dev);
>  			if (ca) {
> -				this_cpu_add(ca->usage->d[acc_k.dev_data_type.data_type].buckets, a.v->d[0]);
> -				this_cpu_add(ca->usage->d[acc_k.dev_data_type.data_type].sectors, a.v->d[1]);
> -				this_cpu_add(ca->usage->d[acc_k.dev_data_type.data_type].fragmented, a.v->d[2]);
> +				this_cpu_add(ca->usage->d[data_type].buckets, a.v->d[0]);
> +				this_cpu_add(ca->usage->d[data_type].sectors, a.v->d[1]);
> +				this_cpu_add(ca->usage->d[data_type].fragmented, a.v->d[2]);
> +
> +				if (data_type == BCH_DATA_sb || data_type == BCH_DATA_journal)
> +					trans->fs_usage_delta.hidden += a.v->d[0] * ca->mi.bucket_size;
>  			}
>  			break;
>  		}
> 
> -- 
> 2.50.1
> 
> 
