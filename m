Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DDD2253E4
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Jul 2025 21:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752962249; cv=none; b=pdseQK0JyS6hrrNhYeN46NDb36epRyCHFCAj5gGaVU8K4T6z79tTQ02NmD7qUYJOf13dL/mWx8eySFUG1yY+C1J2gXsKhdy/fl2gTwEuIXPxOGfV8u9zohG9mLGfyi0vzXF6ue842nFALFX9PSFgdcEEYS9zCbq6fQVoEctBP1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752962249; c=relaxed/simple;
	bh=aJsUMMJNzaMTqcwDIA8kBblsnJKcFjoDqfCZeHiosRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sjsZcRvGr9XS9+VAVZ7XRHPS4giBt9Mc1FoWV88nmXo3Ww+3A19p8H16cffIAA6SwUhEB490S5J0/GrD9PSfnF+LNZ6n7wrodYI1mXW19WoaG23Mmld9V9uja/iOc2ccAaPrCxcfyprR1JGUb5ErsW9M4A/I5PBW5NQE3Jo/hkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wecO1r7D; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wecO1r7D"
Date: Sat, 19 Jul 2025 17:57:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752962244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aJsUMMJNzaMTqcwDIA8kBblsnJKcFjoDqfCZeHiosRY=;
	b=wecO1r7DNlE9nu94VItRSv2CcS4KDSNVjZk5VpsxPkHvrMFONigrWc9r5CutmLHWZJKgEI
	YN3h/km9y/jKw3xFmKTBnIR04LmsIEnxwlZIR8hz+KJrVtAQD0LqKTFuQFxPiThBye4pPV
	exbmlKNoT7lt91TgmV+86GUBG4PBavs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+9375e47164f8e9588f17@syzkaller.appspotmail.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, davem@davemloft.net, 
	herbert@gondor.apana.org.au, hpa@zytor.com, linux-bcachefs@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	mmpgouride@gmail.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de, 
	x86@kernel.org
Subject: Re: [syzbot] [bcachefs] KASAN: slab-out-of-bounds Read in
 poly1305_update_arch
Message-ID: <t5gf2puttghnw4ueatnh5ipr5ih32fpn3gzcaci6hbspspudnm@77shckmffc7y>
References: <000000000000d62d530617ca4c33@google.com>
 <686415f3.a70a0220.3b7e22.1ec0.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <686415f3.a70a0220.3b7e22.1ec0.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Move bset size check before csum check
