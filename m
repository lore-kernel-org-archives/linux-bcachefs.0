Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71D01494DF
	for <linux-bcachefs@vger.kernel.org>; Thu, 27 Mar 2025 15:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743088708; cv=none; b=cUsMNhgQ/1kJIJ00nEeDw+Wvs7ykUZk5y99lz/eQE0C0ZMvitVvBrRmvsi0dfxdGkOLtol0mHxTfzUOGIl0Oia436+DfyMnNhkV+TJFMqrmRHqdc78IcuZjv6xuThDKpwmQmohpkvm1B135M06CGVF07DpEHxfwwMSNYV8LNgWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743088708; c=relaxed/simple;
	bh=cuXhFi0Q684q6VshDzUdKpFdR+RV+8fRiFoEpDex4D0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HflxmNcsPa3iQ9f1S+fVwqSrHsspiK0EKlvJoWVSNzJ7AZ4K8uqzIwJwaSWfBYlt3P7Q59QhxELj0yKEe716m9pI6Dwx3nkyB/V6YTIBSA3z01mlvDYlI0aH9Y1+VV5RfpUmno5fdRNA1bt0Gj3hr6jZ0sYZEkVwh/6Pjjc6hME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PmuwjzXX; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PmuwjzXX"
Date: Thu, 27 Mar 2025 11:18:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743088694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H4r0xKcuNd6rmrfcOvXl1NVqKbWkKKqNx07ftAXypj8=;
	b=PmuwjzXXeowyZ4w6q1ob01dqRx4cc6mms8NBU1RkOHa5u+e//eyGxVeR78Y/y1Zew0iHiw
	mVi4Sgxz8Bi/Pet8lvfD3fQSOrk+E+18iox0CD/bA4KRb2TyoVw19QQ7qD6Sz4tG2XXhND
	VH9CJi4vxi97c9UWjNSzzAOPrRD8jJU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Roxana Nicolescu <nicolescu.roxana@protonmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mmpgouride@gmail.com, skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH v2 0/2] Use memcpy_and_pad for jset_entry_log->d init
Message-ID: <vcyvvmuykkf2jylq7rlqzprmtoz3i5rc4cdro7zohg5n42toz4@3mmabyzvfkge>
References: <20250327144956.1974622-1-nicolescu.roxana@protonmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250327144956.1974622-1-nicolescu.roxana@protonmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 27, 2025 at 02:49:58PM +0000, Roxana Nicolescu wrote:
> This replaces the depracated usage of strncpy with memcpy_and_pad when
> used for initializing the d buffer of the struct jset_entry_log.
> 
> The other 2 usage of memcpy were also replaced by memcpy_and_pad.
> 
> Changes since v1:
> - since the dest buffer is not required to be NULL-terminated,
>   memcpy_and_pad is used instead of strscpy. This adds zeros at the end
>   of the buffer if there's extra room.
> - the same mechanism was done before in both __bch2_fs_log_msg() and
> bch2_trans_log_msg by zero-ing out the src buffer. The second patch
> replaces that logic with memcpy_and_pad to provide uniformity.
> 
> Roxana Nicolescu (2):
>   bcachefs: replace strncpy() with memcpy_and_pad in
>     journal_transaction_name
>   bcachefs: replace memcpy with memcpy_and_pad for jset_entry_log->d
>     buff
> 
>  fs/bcachefs/btree_trans_commit.c | 3 ++-
>  fs/bcachefs/btree_update.c       | 8 +++-----
>  2 files changed, 5 insertions(+), 6 deletions(-)

Thanks, series is applied.
