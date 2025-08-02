Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028C6148830
	for <linux-bcachefs@vger.kernel.org>; Sat,  2 Aug 2025 15:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754148655; cv=none; b=mDxVVJWyO0lQeI2KCNgBCHzc2YGKmuRJYn5rZvE2FknmjqEBudcXTy9RhhcF6JloS17eqyN/JXXfPqqhDnICwz/qjSQt5nZ2mCXD09lw1+u25YDwCvQ3kdJSED4DFAmBfWr/kPg5ZRj5Zam/UjXdLQBxqfqDpsFm9sXmvhEQuzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754148655; c=relaxed/simple;
	bh=i+1M7H5bBwgwpgyJRLJONuTCe3kmewfhAcInKqptKtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eIe7DFpTbUq+1nG3wK6SHaqeuXFxSL9oyAEuk250jpT4TDADAFYpjvGktcHSfCKcKxD+hzhsACIXqgy3dIF5NHFhi85Qddxx8LvvM/SyNrv3segIftqLKpT0cU29WWCdkqbHb/e6jzzp/mfb0dvhnNirOATFIdvK/PBp59gr0CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dhqv1rnz; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dhqv1rnz"
Date: Sat, 2 Aug 2025 11:30:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754148640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZNr+MvD9kEy2GM2CfeheJEuFgMa5Y5JfdFKErWGgmEQ=;
	b=dhqv1rnzJWRFXfWxOgf4LfJgHAExN5ArA/ox/53SzczjAQAaksF58ocPSuCmrbybyE0FCe
	1CP/0vzkO/mdABhscqw5+RRaor6xxb9NlALHFSIvo7ItCWKil1z3GmqmjpLLL3Firc8H7s
	2PZyyrNq4K/U02VLBE4Ka4ZxYfp99NI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Linux Next Mailing List <linux-next@vger.kernel.org>, 
	linux-bcachefs@vger.kernel.org
Subject: Re: Build failure on next-20250801
Message-ID: <un3cqgfe2yzfgiuthmk46f4ypq4krhlun7q3zp65ebttbjvxw7@ff4tpgu4mcua>
References: <b390beb2-441f-4a3d-b53d-3f554b308be2@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b390beb2-441f-4a3d-b53d-3f554b308be2@oss.qualcomm.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Aug 02, 2025 at 12:04:07PM +0200, Konrad Dybcio wrote:
> Hi, just hit the below on next-20250801
> 
> Reverting
> 
> 4c3205637f1e ("bcachefs: CLASS(btree_iter)")
> ...
> 69c862491582 ("Revert "bcachefs: Convert bch2_bkey_get_mut() to
> CLASS(btree_iter)"")
> 
> (mostly as dependencies for clean reverts)
> 
> gets it to build again.

Already have fixed versions in my for-next branch :)

> 
> 
> In case that matters (which I believe it doesn't), I'm using clang
> on x86, version 20.1.8
> 
> 
> fs/bcachefs/backpointers.c:391:7: error: cannot jump from this goto statement to its label
>   391 |                 if (fsck_err(trans, backpointer_to_missing_device,
>       |                     ^
> fs/bcachefs/error.h:140:2: note: expanded from macro 'fsck_err'
>   140 |         __fsck_err(c, FSCK_CAN_FIX|FSCK_CAN_IGNORE, _err_type, __VA_ARGS__)
>       |         ^
> fs/bcachefs/error.h:117:26: note: expanded from macro '__fsck_err'
>   117 | #define __fsck_err(...)         fsck_err_wrap(bch2_fsck_err(__VA_ARGS__))
>       |                                 ^
> fs/bcachefs/error.h:111:3: note: expanded from macro 'fsck_err_wrap'
>   111 |                 goto fsck_err;                                          \
>       |                 ^
> fs/bcachefs/backpointers.c:398:20: note: jump bypasses initialization of variable with __attribute__((cleanup))
>   398 |         CLASS(btree_iter, alloc_iter)(trans, BTREE_ID_alloc, bucket, 0);
>       |                           ^
> 1 error generated.
> make[4]: *** [scripts/Makefile.build:287: fs/bcachefs/backpointers.o] Błąd 1
> make[4]: *** Oczekiwanie na niezakończone zadania....
> fs/bcachefs/alloc_background.c:2097:7: error: cannot jump from this goto statement to its label
>  2097 |                 if (fsck_err(trans, lru_entry_to_invalid_bucket,
>       |                     ^
> fs/bcachefs/error.h:140:2: note: expanded from macro 'fsck_err'
>   140 |         __fsck_err(c, FSCK_CAN_FIX|FSCK_CAN_IGNORE, _err_type, __VA_ARGS__)
>       |         ^
> fs/bcachefs/error.h:117:26: note: expanded from macro '__fsck_err'
>   117 | #define __fsck_err(...)         fsck_err_wrap(bch2_fsck_err(__VA_ARGS__))
>       |                                 ^
> fs/bcachefs/error.h:111:3: note: expanded from macro 'fsck_err_wrap'
>   111 |                 goto fsck_err;                                          \
>       |                 ^
> fs/bcachefs/alloc_background.c:2107:20: note: jump bypasses initialization of variable with __attribute__((cleanup))
>  2107 |         CLASS(btree_iter, alloc_iter)(trans, BTREE_ID_alloc, bucket, BTREE_ITER_cached);
>       |                           ^
> 1 error generated.
> 
> 
> Konrad
