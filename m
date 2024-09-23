Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE8A78C90
	for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 21:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727127858; cv=none; b=BCSj3ZqfePkzGHKVSVxywoJ5/fsfmu2ciAvzpwEnq1xxnZmJkb0Xcwi4ayxUtkJrE8918NmYzr47Ey1AaPRK386zeMdc7q5fAkBBHoAqb4rgOKRkBM1jwFxu3s0JPUB6JTzcE9NSkJBrXsqSXCr6G12SY52ZLq6MYSGa0prhluQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727127858; c=relaxed/simple;
	bh=3Jpn/X5KBq6gi+lv98QCZ9YS55FSIrlWsuwDXyfN3Kg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iMWQnDIKutDePY6qEhPTmC/rK5K652fU1vseh9zeU7Rn67o27IvhDtHo4OYZEUEW2FKF7/TAW43s6sstn8IQgUm1lnt0Wqs+VzxU4Q8bzNrSq5WF7rNqHdMq7vx+RwuGuKOf/HCYhpVVXs3+rmIlhlBobgBRZDexh0eEmitI3P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Xnlo3TkP; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Xnlo3TkP"
Date: Mon, 23 Sep 2024 17:44:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727127854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rb0xYVxxQiA42gtCtHSH89wzqw5/G1A/qKd+mtPVpas=;
	b=Xnlo3TkPrKxUmeATil2Z9BfcAexpTECzW8KLMbrgpcRDtAnAm+AQ86OKabHJCS9EdLX5SD
	MiTKbLjPsygBEFq7bM5k1GNtb1tX+8jL1Cs1+V2qZXCDiOuqRHwQFfp5+B5nRQSgyvStpe
	jtdO7Zh8HZNIvXEpAnKFQrWRp5fjzWY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Piotr Zalewski <pZ010001011111@proton.me>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, syzbot+6f655a60d3244d0c6718@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] bcachefs: memset bounce buffer portion to 0 after
 key_sort_fix_overlapping
Message-ID: <b4ajhopcv477r3ot6rz4lvhjpunuggoysdksn3aqbl5x4ivjjw@6opkd6jmr2ch>
References: <20240922151618.737458-2-pZ010001011111@proton.me>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240922151618.737458-2-pZ010001011111@proton.me>
X-Migadu-Flow: FLOW_OUT

On Sun, Sep 22, 2024 at 03:18:01PM GMT, Piotr Zalewski wrote:
> Zero-initialize part of allocated bounce buffer which wasn't touched by
> subsequent bch2_key_sort_fix_overlapping to mitigate later uinit-value
> use KMSAN bug[1].
> 
> After applying the patch reproducer still triggers stack overflow[2] but
> it seems unrelated to the uninit-value use warning. After further
> investigation it was found that stack overflow occurs because KMSAN adds
> too many function calls[3]. Backtrace of where the stack magic number gets
> smashed was added as a reply to syzkaller thread[3].
> 
> It was confirmed that task's stack magic number gets smashed after the code
> path where KSMAN detects uninit-value use is executed, so it can be assumed
> that it doesn't contribute in any way to uninit-value use detection.
> 
> [1] https://syzkaller.appspot.com/bug?extid=6f655a60d3244d0c6718
> [2] https://lore.kernel.org/lkml/66e57e46.050a0220.115905.0002.GAE@google.com
> [3] https://lore.kernel.org/all/rVaWgPULej8K7HqMPNIu8kVNyXNjjCiTB-QBtItLFBmk0alH6fV2tk4joVPk97Evnuv4ZRDd8HB5uDCkiFG6u81xKdzDj-KrtIMJSlF6Kt8=@proton.me
> 
> Reported-by: syzbot+6f655a60d3244d0c6718@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=6f655a60d3244d0c6718
> Fixes: ec4edd7b9d20 ("bcachefs: Prep work for variable size btree node buffers")
> Suggested-by: Kent Overstreet <kent.overstreet@linux.dev>
> Signed-off-by: Piotr Zalewski <pZ010001011111@proton.me>

Thanks! Applied.
