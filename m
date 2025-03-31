Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C33B1E47C9
	for <linux-bcachefs@vger.kernel.org>; Mon, 31 Mar 2025 16:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743439904; cv=none; b=g2zYsI5flmJazOFGtHKZJhAkS9aK/HFN2FoVtSjeYP5BPWD5mQCGPjtPcCKGpI6P0QHcNXbL3C+7acHSv7OkZkvHKIP8d4pAFQp3VKqLx8CI+sk/LhXUdUb3eE/DpmYkNnvvG45qGwWjhwO/FXiqOUrxW1fP/qJ51BsZOHZ4kBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743439904; c=relaxed/simple;
	bh=g6c8NjTeWtM3CaUT0fcwLGfnp62ES8eY8AVtoLbWnbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dhnihGM2zh+h9VzR+P08G2O7HFayPczfAiZxFV8EdpcwIoOVc6d/XqjzLB1LgI2Kr377pFf+RnK/wGzCkWS/j5z++40PPrNt2VouILwXrLcpYuMzTO+t9eO4qbq0UCd2ggCzD1sf7vuA5TZpmjCng74PnFC92XQc6XFpsu9cYsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=umkGFwEO; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="umkGFwEO"
Date: Mon, 31 Mar 2025 12:51:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743439899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d9YMiSoQtLB7I67sGXZ0Atagk/BpGc7cqaYIpXWQIf0=;
	b=umkGFwEOZrtM6LnujgL6RYb2S5/cy+t+IHl2iHeOCrJImv3aDDX8xRFW7xUc/CyPKtum2O
	C3VKSDPErWcHrms3cG4TQFxBarUE7048Nt/ik6Ci8B0s42f7hjeCnjfZOltycQD/PgcN2k
	MJPBwmihMpFotG/mHA4BVzSsyrECAOQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Integral <integral@archlinuxcn.org>
Cc: kent.overstreet@gmail.com, lihongbo22@huawei.com, mmpgouride@gmail.com, 
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 combined resend] bcachefs-tools: add fs_usage &
Message-ID: <cyorewdfsnc4n63a64umawov2yzu3tkqnxr6zwfsmstebjfa25@xt6vfaeysk64>
References: <20250331115830.79127-1-integral@archlinuxcn.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250331115830.79127-1-integral@archlinuxcn.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 31, 2025 at 07:58:30PM +0800, Integral wrote:
> Add the missing usage function for "fs" subcommand; when no matching
> subcommand exists, print the usage and return -EINVAL.
> 
> Signed-off-by: Integral <integral@archlinuxcn.org>

Applied

> ---
>  c_src/bcachefs.c | 15 ++++++++-------
>  c_src/cmd_fs.c   | 13 +++++++++++++
>  c_src/cmds.h     |  1 +
>  3 files changed, 22 insertions(+), 7 deletions(-)
> 
> diff --git a/c_src/bcachefs.c b/c_src/bcachefs.c
> index f2a1449e..2f718147 100644
> --- a/c_src/bcachefs.c
> +++ b/c_src/bcachefs.c
> @@ -118,16 +118,15 @@ int fs_cmds(int argc, char *argv[])
>  {
>  	char *cmd = pop_cmd(&argc, argv);
>  
> -	if (argc < 1) {
> -		bcachefs_usage();
> -		exit(EXIT_FAILURE);
> -	}
> +	if (argc < 1)
> +		return fs_usage();
>  	if (!strcmp(cmd, "usage"))
>  		return cmd_fs_usage(argc, argv);
>  	if (!strcmp(cmd, "top"))
>  		return cmd_fs_top(argc, argv);
>  
> -	return 0;
> +	fs_usage();
> +	return -EINVAL;
>  }
>  
>  int device_cmds(int argc, char *argv[])
> @@ -153,7 +152,8 @@ int device_cmds(int argc, char *argv[])
>  	if (!strcmp(cmd, "resize-journal"))
>  		return cmd_device_resize_journal(argc, argv);
>  
> -	return 0;
> +	device_usage();
> +	return -EINVAL;
>  }
>  
>  int data_cmds(int argc, char *argv[])
> @@ -169,5 +169,6 @@ int data_cmds(int argc, char *argv[])
>  	if (!strcmp(cmd, "job"))
>  		return cmd_data_job(argc, argv);
>  
> -	return 0;
> +	data_usage();
> +	return -EINVAL;
>  }
> diff --git a/c_src/cmd_fs.c b/c_src/cmd_fs.c
> index 06f797b9..4ab3ec0d 100644
> --- a/c_src/cmd_fs.c
> +++ b/c_src/cmd_fs.c
> @@ -491,6 +491,19 @@ devs:
>  	bcache_fs_close(fs);
>  }
>  
> +int fs_usage(void)
> +{
> +	puts("bcachefs fs - manage a running filesystem\n"
> +	     "Usage: bcachefs fs <CMD> [OPTIONS]\n"
> +	     "\n"
> +	     "Commands:\n"
> +	     "  usage                   Display detailed filesystem usage\n"
> +	     "  top                     Show runtime performance information\n"
> +	     "\n"
> +	     "Report bugs to <linux-bcachefs@vger.kernel.org>");
> +	return 0;
> +}
> +
>  static void fs_usage_usage(void)
>  {
>  	puts("bcachefs fs usage - display detailed filesystem usage\n"
> diff --git a/c_src/cmds.h b/c_src/cmds.h
> index 9502d539..82f28af2 100644
> --- a/c_src/cmds.h
> +++ b/c_src/cmds.h
> @@ -15,6 +15,7 @@ int cmd_recover_super(int argc, char *argv[]);
>  int cmd_reset_counters(int argc, char *argv[]);
>  int cmd_set_option(int argc, char *argv[]);
>  
> +int fs_usage(void);
>  int cmd_fs_usage(int argc, char *argv[]);
>  int cmd_fs_top(int argc, char *argv[]);
>  
> -- 
> 2.49.0
> 
