Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8E53398E
	for <linux-bcachefs@vger.kernel.org>; Thu,  8 Aug 2024 22:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723154628; cv=none; b=MT82Itp6ck2flLR6LVZ+BEcUXlRjOqfC8lZ9T02TFTrzlKV+nnCtcBS9h2IpxOIEV1hNBgFCAJqPcyptrqhOgzZ73A/yVkIsnrAJKjlQDyprLUaN130ifDCrB9mRgg181/KE+ZnsHPHyx73ZHQNl1LA88hFrtTwbbHmwimIEQhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723154628; c=relaxed/simple;
	bh=uNcUY8yHRyYsZM3h0TFO6DExo7cRKiSaWW9bFFCHjf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kE1q5l7xi+Yue+0Z5ICR4wSwVA/evyib2B6h33/p+kiTow5fyheTcou/aSohch7o8RJCj5Av+T15+keCk6us8lK2vCVzSlpPk8uCfAcvUa5EE7+SUbeLoYTU3F9Hgt1ji0uE197kft9R8/3yXvOPGdtmxToQZ7rpvGio4BT0xdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=jzLEKBpg; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="jzLEKBpg"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7b396521ff6so1158050a12.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 08 Aug 2024 15:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1723154625; x=1723759425; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VovAhXzqSeyRFjRdkVXxIjBd1uS33PY0oNHckm00eHs=;
        b=jzLEKBpgDSGybXWZWEJmJrumuBvpNLa5JQwtVUDab5B9Puo1Z3d3i/lTW1OKBVURyI
         qz1KErkRRI4RfZs4YSAz7aSjlhvk/Daq3plAdNQAiPOT6Gcd3xkr6Zs5dPtawnCdDKb0
         GkdIpCEu6G9atrZpms55nFu+ghHAXvIzEb+mdMqUnjVIViJS00XyEfjVAmphmLtUrAPq
         +zsAKPuk+BMd2wBDSmhzWnHMYvxnfW7P65uuj1O8SFPJwDaVtX5Gk0OdH5o2LsYhj5bh
         gerMzAnXmmezNKc4bIJbuot1vdgxY8NRZ6Ygo9crXj0xI2I54L3RlJ0zfSAe83Gzhjsb
         +Sng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723154625; x=1723759425;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VovAhXzqSeyRFjRdkVXxIjBd1uS33PY0oNHckm00eHs=;
        b=anO239tWW/pMSornd0is5YLC+BejtpiF6ajJg5hdMbh5ytdd5WMtrk2A1WdRaK4CLg
         WDTMPWJzvoG3oRBMyqv297eVkycLLPNpkuFm70dwclp/5cQTEhwQ2qoQt3w7sPVNguHp
         W+HkoRsGyowbkccc7I4ilRHV3cOXnQUPq8NsR0LDR92cJpOMtvyoUj+hCRcly5DufjeJ
         dbwsjB1/wOk05m4TtUJ3yNFqkkS2Wo4UV876w+f8xMizs2BaYdmRqXjf9hG/Fur53Cf4
         GWvO00U5ON0wjC8sRY0gPIRSO8EyQWRb+nRSmwswI90TiJFRvwZXEtEQoT6h30ntgxBq
         1bBQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2LhSXMT7hSSv2mkQB4ppEehzdScS41roItHGrVaQyLq5+Hlbr7yE8WTmTqTKbtMkK1CdxfTbjkk2JaC1oJJS/rQ1rF7KIZaCZJ1yUZjI=
X-Gm-Message-State: AOJu0YwM2bUvzz617bfrlF6a1rkAYUyzzufXe9z6k3k4Jqg9fobbrnSD
	0mY1r+cuCu2W36G9NA5Mu9cSQ93FOscCacmwHA8+Ncjz6BGWwbYVsWLdIHMWdm4=
X-Google-Smtp-Source: AGHT+IE5dO8WHZC6Pz9g72R0dboQ8rfRXb+Uzl5pZcpIdVcM7rWuMMHNr1EwN1H2Ba6s/xKz5Hjnbw==
X-Received: by 2002:a05:6a21:271e:b0:1c4:c160:2859 with SMTP id adf61e73a8af0-1c6fcf32732mr3245526637.31.1723154624900;
        Thu, 08 Aug 2024 15:03:44 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d1c9c9f03csm1642587a91.26.2024.08.08.15.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 15:03:44 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1scBET-00ACDg-2F;
	Fri, 09 Aug 2024 08:03:41 +1000
Date: Fri, 9 Aug 2024 08:03:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: kernel-team@fb.com, linux-fsdevel@vger.kernel.org, jack@suse.cz,
	amir73il@gmail.com, brauner@kernel.org, linux-xfs@vger.kernel.org,
	gfs2@lists.linux.dev, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 16/16] xfs: add pre-content fsnotify hook for write
 faults
Message-ID: <ZrVAvQLfP8fNSJwx@dread.disaster.area>
References: <cover.1723144881.git.josef@toxicpanda.com>
 <aa122a96b7fde9bb49176a1b6c26fcb1e0291a37.1723144881.git.josef@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa122a96b7fde9bb49176a1b6c26fcb1e0291a37.1723144881.git.josef@toxicpanda.com>

On Thu, Aug 08, 2024 at 03:27:18PM -0400, Josef Bacik wrote:
> xfs has it's own handling for write faults, so we need to add the
> pre-content fsnotify hook for this case.  Reads go through filemap_fault
> so they're handled properly there.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/xfs/xfs_file.c | 20 +++++++++++++++++---
>  1 file changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 4cdc54dc9686..585a8c2eea0f 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1325,14 +1325,28 @@ __xfs_filemap_fault(
>  	bool			write_fault)
>  {
>  	struct inode		*inode = file_inode(vmf->vma->vm_file);
> +	struct file		*fpin = NULL;
> +	vm_fault_t		ret;
>  
>  	trace_xfs_filemap_fault(XFS_I(inode), order, write_fault);
>  
> -	if (write_fault)
> -		return xfs_write_fault(vmf, order);
>  	if (IS_DAX(inode))
>  		return xfs_dax_read_fault(vmf, order);
> -	return filemap_fault(vmf);
> +
> +	if (!write_fault)
> +		return filemap_fault(vmf);

Doesn't this break DAX read faults? i.e. they have to go through
xfs_dax_read_fault(), not filemap_fault().

-Dave.
-- 
Dave Chinner
david@fromorbit.com
