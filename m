Received: from bilby.grue.cc (li1738-184.members.linode.com [172.104.158.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2DA101C8;
	Fri, 20 Sep 2024 02:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.158.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726801004; cv=none; b=NzCzTCWomrcBo2lwxP1HtDCqEStjKCi8c+Usozh7onBv8YN0rhvRg6iTCKmlv/uRUo4ajqpiwbmEY8YaUiqNoZpSu8wdNYPRze3iSc/J99+ld2T1v6ffQ6Eh9bLwA+QG1U7pick53Vnmj0kwB49JGpTpgwIwpPQkREKmjvXDzOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726801004; c=relaxed/simple;
	bh=UqjK6cA/LQxFGKQmkV8BJlowuU9Bgu0U8i+RCGRtcjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LUUJ4LV7AanvPVQGHW8AQrUte3/KtNkWe6K9aFQfyrfSY8j97Vw4UrKWYTV99P6EmMj5AD5O8lC5TbW3nAFH1kq0rlH3ZuxldziM4+ZJxdI2sCJH6uYahoYDQ9CzjKB2I0qvk5TsaWEvV7B4GiKcW9qcgAF+GOgFbRMIM6q6drg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inml.grue.cc; spf=pass smtp.mailfrom=inml.grue.cc; arc=none smtp.client-ip=172.104.158.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inml.grue.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inml.grue.cc
Received: from happy-place5.inml.grue.cc ([100.64.10.15] helo=happy-place5.inml.grue.cc)
	by bilby.grue.cc with esmtp (Exim 4.98)
	(envelope-from <lkml@inml.grue.cc>)
	id 1srTWb-00000001wNv-21Rg;
	Fri, 20 Sep 2024 12:37:37 +1000
Received: from hogarth by bunyip.jovian.space with local (Exim 4.98)
	(envelope-from <lkml@inml.grue.cc>)
	id 1srTWY-00000002nEi-0nEC;
	Fri, 20 Sep 2024 12:37:34 +1000
Date: Fri, 20 Sep 2024 12:37:34 +1000
From: AP <lkml@inml.grue.cc>
To: Edward Adam Davis <eadavis@qq.com>
Cc: syzbot+294f528e56138c357a48@syzkaller.appspotmail.com,
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] BUG: unable to handle kernel paging request
 in bch2_opt_to_text
Message-ID: <Zuzf7hg_5aOZ7LJl@inml.grue.cc>
Mail-Followup-To: AP <lkml@inml.grue.cc>,
	Edward Adam Davis <eadavis@qq.com>,
	syzbot+294f528e56138c357a48@syzkaller.appspotmail.com,
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <66eb6254.050a0220.92ef1.0009.GAE@google.com>
 <tencent_50B5A5988DAD922A5D9B5DC9190C4FB08D07@qq.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_50B5A5988DAD922A5D9B5DC9190C4FB08D07@qq.com>

On Thu, Sep 19, 2024 at 11:11:40PM +0800, Edward Adam Davis wrote:
> The format of the 'name=value' key value pair included in the options is
> incorrect, if only name is present.
> 
> #syz test
> 
> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
> index e10fc1da71b1..5616dc8570fa 100644
> --- a/fs/bcachefs/opts.c
> +++ b/fs/bcachefs/opts.c
> @@ -472,6 +472,12 @@ int bch2_parse_one_mount_opt(struct bch_fs *c, struct bch_opts *opts,
>  	u64 v;
>  	int ret, id;
>  
> +	if (!val) {
> +		pr_err("Bad mount option, value is NULL");

Given that this would be user visible, NULL is unlikely to mean much. I believe that it
would be better to state "value is missing but required." or similar. This clearly tells
the user how they erred regardless of their programming knowledge.

AP
