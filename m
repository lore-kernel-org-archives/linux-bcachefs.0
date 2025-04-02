Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B02F4E2
	for <linux-bcachefs@vger.kernel.org>; Wed,  2 Apr 2025 03:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743565413; cv=none; b=IGhi6Pj6iHL+mRNi95/8R3uaAnFVRxIlIbmfsg6gTAsAbYZySKS+WT2himrs3I6FWNBdWNYyQ64EiQwYLIeghmRCktF7vf4FR167UUwqslvxh85Os3rscY4fzYakrnKXZr9VwsOiu7aKMbIF1RLVxf/ab+zVVDINIFDEX16TmyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743565413; c=relaxed/simple;
	bh=NekwUyVfTG4a5mRX0TsA/D3DPDlH24JvNweAPxXqwaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bPi4qplV0FRPnL2+8AT1mXkGvitlyaljFHaX56H4dUqYPVlAFonLclWT9pHbLsqWSfQv7a/fiXkKWl49DI1lJuuBFSZfU7XwTFgFi0wVYglqlWIDNHb1vBosfpTe8VAUDNsoD4q7b9rRsWpAOIZsGzgL0ZGiiP0vncxFjohQTlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZBAnDw7e; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZBAnDw7e"
Date: Tue, 1 Apr 2025 23:43:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743565407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DQp3tfWiuxPn3ED1FiTA4VujNKXHf33ye/OmGxKx8e8=;
	b=ZBAnDw7eQAzTwDt3yENfnge38+EFYBrDUvxlqj25VZWfiMfbI/yEV6tVjV/QNhiqLwyWMF
	8yPTxkdzO1AXPwW8J2fA86NWCLWnzbegMeldQBVbtVjYPE4NVlg10CrLlJzsJJ6k2T74Mh
	4ZtVW0b3iQa8DY93XDkqeAJFJW9qnKE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [ktest PATCH] kconfig: stop requiring CONFIG_MCORE2
Message-ID: <qmlybrlgvbhxt3q44dqgjf3nhpe4twyqwbokulwnqfoa7smcjz@7ip5ahonrxpn>
References: <20250402033010.266607-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402033010.266607-1-ebiggers@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 01, 2025 at 08:30:10PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> This was removed upstream.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks! Applied

> ---
>  tests/kconfig.sh | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/tests/kconfig.sh b/tests/kconfig.sh
> index f3fb18f..5254530 100644
> --- a/tests/kconfig.sh
> +++ b/tests/kconfig.sh
> @@ -5,11 +5,10 @@ have_virtio=0
>  have_suspend=0
>  
>  case $ktest_arch in
>      x86)
>  	require-kernel-config SMP
> -	require-kernel-config MCORE2	# optimize for core2
>  	require-kernel-config IO_DELAY_0XED
>  	require-kernel-config 64BIT=n
>  	require-kernel-config ACPI	# way slower without it, do not know why
>  	require-kernel-config UNWINDER_ORC
>  	require-kernel-config HARDLOCKUP_DETECTOR
> @@ -21,11 +20,10 @@ case $ktest_arch in
>  
>  	require-kernel-append console=hvc0
>  	;;
>      x86_64)
>  	require-kernel-config SMP
> -	require-kernel-config MCORE2	# optimize for core2
>  	require-kernel-config IO_DELAY_0XED
>  	#require-kernel-config IA32_EMULATION
>  	require-kernel-config 64BIT
>  	require-kernel-config ACPI	# way slower without it, do not know why
>  	require-kernel-config UNWINDER_ORC
> 
> base-commit: 53229b36f8c4df0690af64dedfce3e247334505e
> -- 
> 2.49.0
> 
