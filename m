Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A951C6BA
	for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jan 2024 16:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ANJZWCWY"
Date: Tue, 16 Jan 2024 11:31:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705422694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4n9rUq09ZDDvKY+Ou2uucMVZN1H5Q9wbDquxsju9mNk=;
	b=ANJZWCWYCTLQDK0o2i5MSSdRd/ijredLNeYedoV+pyyYPFTjk2/PyXgKLFct/qBOIvqEcU
	RzuiBB36omoEJTSihjtDdA7AKwgNeeI156EWhpPKH/3xgjBbxHNW+E6uXNfP30jbVHxxed
	up3aoHT3j+5IhuNBeQA3bq/cQhNBEnM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alec Moskvin <list.bcachefs@e.netreq.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: fsck: bch2_parse_mount_opts() Bad mount option read_only
Message-ID: <bwkjccqevinhd4rvztseojmavr5jyvvbd5qrndanl6o6egeidp@tzljjr4sb36u>
References: <20240114235503.GA269705@emmetten>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240114235503.GA269705@emmetten>
X-Migadu-Flow: FLOW_OUT

On Sun, Jan 14, 2024 at 06:55:03PM -0500, Alec Moskvin wrote:
> On Linux 6.7.0 with the latest bcachefs-tools 1.4.0, I get an error when 
> trying to run fsck:
> 
>     bcachefs fsck -v /dev/sda3
>     bch2_parse_mount_opts() Bad mount option read_only
> 
> If I try a newer git revision of bcachefs-tools, it works but does an 
> upgrade of the fs version:
> 
>     bcachefs fsck /dev/sda3
>     mounting version 1.3: rebalance_work opts=ro,compression=zstd:15,degraded,verbose,fsck,fix_errors=ask,read_only
>     recovering from clean shutdown, journal seq 116268
>     Doing compatible version upgrade from 1.3: rebalance_work to 1.4: member_seq 
> 
> and then when I mount it, it downgrades:
> 
>     [Jan14 11:06] bcachefs (sda3): mounting version 1.4: (unknown version) opts=compression=zstd:15
>     [  +0.000016] bcachefs (sda3): recovering from clean shutdown, journal seq 116272
>     [  +0.000003] bcachefs (sda3): Version downgrade required:
>     
>     [  +0.200171] bcachefs (sda3): alloc_read... done
> 
> Is there a correspondence between the kernel and bcachefs-tools 
> versions? I.e., should bcachefs-tools 1.3.6 be used until a kernel with 
> bcachefs 1.4 is released?

No, for now I've been focusing on making the upgrade/downgrade process
work smoothly and reliably; and in this case 1.4 just introduced the
bch_member->seq field so there's no work to do on upgrade/downgrade -
the new version just indicates that the bch_member->seq field can be
trusted for split brain detection.

So - using mismatched kernel/tools is completely fine.
