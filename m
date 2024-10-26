Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC6510F1
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Oct 2024 00:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729902197; cv=none; b=t6DbAFzxJzcX9YOwcf3hcCTT3ZOKcJpiX/E+ZYdUucQcBD9LyDUzQmceqFjBzyEyqeDyG+BQCGuEUqgi8pu5P21IpUcuDLM+iuLiaRgbx3v0CIMMmeu5uiTwO2K6H8TOUoCxgXZOiaaYMASX+CSlqGVtmcePA15N/71Xe0YeBoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729902197; c=relaxed/simple;
	bh=vjPDS2XLFzMchjTvdzKCjt7QlM0OyDWJ343ZEeiQT8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h8J/Cb5Fim0rXy5j7SUrtSpGCHmW2wtqJKsZITjOwAmWclH+tJBHrwdN2Y4yDEHSEjkPetn5K1PJCtaZUKKyEggZ3wAfYgQEJAl7UQPRPpHb4LIs8F8Oeld8WGWldifpaZs+U1cvm8xxs7pmuwWPktViSEQQaWJrZt/vdoaClPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TxAqF15g; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TxAqF15g"
Date: Fri, 25 Oct 2024 20:23:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729902192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zln656fLILe5+FldK6VGSbLarwFZ/Nz4YIO40Ssj2Tc=;
	b=TxAqF15gB/aJI/WuEb+NLUjwRUX8g91GsnSTSHGix0WUEPW2gNSRu4sNmBcnehNcN7Zlhh
	DvHf+sYZv8vZ3PHfFOe1gEfcwyqnUNpv05VUb7XJdel/eqmwRXS4wNRu3jfxfqdc7s+8Az
	SOaNKevTvbdtZ6LBtUyny3uQyYWD1dU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Piotr Zalewski <pZ010001011111@proton.me>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, syzbot+2b6a17991a6af64f9489@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] bcachefs: init freespace inited bits to 0 in
 bch2_fs_initialize
Message-ID: <imdw6j26f4krg3ztq2lmftcli5qzls5b6u673tlyhwux7sk7cl@f54h5kwbclsu>
References: <20241026001004.10470-2-pZ010001011111@proton.me>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241026001004.10470-2-pZ010001011111@proton.me>
X-Migadu-Flow: FLOW_OUT

On Sat, Oct 26, 2024 at 12:15:49AM +0000, Piotr Zalewski wrote:
> Initialize freespace_initialized bits to 0 in member's flags and update
> member's cached version for each device in bch2_fs_initialize.
> 
> It's possible for the bits to be set to 1 before fs is initialized and if
> call to bch2_trans_mark_dev_sbs (just before bch2_fs_freespace_init) fails
> bits remain to be 1 which can later indirectly trigger BUG condition in
> bch2_bucket_alloc_freelist during shutdown.
> 
> Reported-by: syzbot+2b6a17991a6af64f9489@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=2b6a17991a6af64f9489
> Fixes: bbe682c76789 ("bcachefs: Ensure devices are always correctly initialized")
> Suggested-by: Kent Overstreet <kent.overstreet@linux.dev>
> Signed-off-by: Piotr Zalewski <pZ010001011111@proton.me>

Thanks, applied
