Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4030922DA13;
	Wed, 11 Jun 2025 19:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749669314; cv=none; b=RnyPfC22EJ1tnGGQKcqxw8qHt9hvTH56TK7dZuxuRIpI8gJu8U1J0dy0sohRN/RSp6/rvoEnu9+ymBB9bJ8iXa0/dobTj5pBYUZ++2WIfvIWCF8KXk7JglNc78itLMFfQBpYmYMTfS6vBld58fKpcJs2NQdcTG26t9A9XvmONHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749669314; c=relaxed/simple;
	bh=XDRjqbU5DtsKUsO3In3OMiwl7SJE7t5mIqtUFNA8LDU=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YLl8LndZ629dC+660viMUFx5ac/LTB1pp+VWBvxXJXh+6SmW+SbNnQl3Z2kdY5AxGyjFaFx8jGn46sEx07TF5PqOY1R5aomk/NKMuISM1NrrBMMfBEggPOwq04YF2fLviuYyGCWhSTUpA/AmOJYQ42XYI73DcE3LoaOBTreqhQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ERN7Dz6e; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ERN7Dz6e"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-54d98aa5981so163488e87.0;
        Wed, 11 Jun 2025 12:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749669310; x=1750274110; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ol/LB2Q3E1f7WEUHvJurPIDYLj8oiAF6d8R35khMIPY=;
        b=ERN7Dz6e6ZFYwE31nE953PkBSfdkEktcHc4bym8f5AkpBiDRj/9QKei1RgmFhp73af
         fYRojo+xmyOQInFbJ44mjjUIyZkNuMcPu4JKnzrFaQkbmcHfwklYKbeiUXRNYCyke8fl
         d33b+/ofwTaoFsy4peLQqvgeHkYfgOKiPNp10pVoMwrrs+XXlT277KFcTP67gcRfcbTV
         uPcifKuUJeozM6SWDUhBTCaaKDuB2TzXqQ1BvwBZ3vhZQ5DE/dOT13p/PjKVeb47NHtb
         sZ/LT1U19/ECi+7Dri94pmcct0W2pu0SiFHVkhA4XclHUCMkn7KMkkZi8MO/yI3PohSS
         vEBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749669310; x=1750274110;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ol/LB2Q3E1f7WEUHvJurPIDYLj8oiAF6d8R35khMIPY=;
        b=ACmcsxbFzMEK5y03NjTY6Mh9R75tDetlNV3iQJmSnEFktXpoDdmG06wo/HqrAWkmoz
         Zg6tUUqGbnicOC6qjkm3Zuz3HN2hrBT/5dmLNKZZqG9ckeFvtxj+e0Fr0Cq1N1k9taxN
         tTIliUr84LlhyLexoRhSAotNtfReeEhd1ml50iqHoPEwxV/Gqlwv4GEVjzCkQWtMupBm
         eK0pO679U7qSv1ufK/tpusJLBfGlAeh2JjOQ7o/NRmCUigYSSOlNpVY5nDraKES1h3QS
         DmwvqCO5JowALC8uiASORrHpkxH2zaMcQd0jUkk7t1dS3l3716qTHavcnR099NnXchiV
         5gpQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQB1tTBUFPrPRcwnNsKy56cuukpJPfwX4II7+OMkYJyFSuPcDwAXTTmivCu9E62zEEQfZUjXTf4BsKbOKT@vger.kernel.org, AJvYcCVOACUVwrVOLGmGQjVczBizSmkQvRcZHwzDjAlVW4+uRc81b+z3VPE+VflwJlkdG12JarWF@vger.kernel.org, AJvYcCVw+jOMl4YfTp40IMMWWGHYKFgseNi9dTacbXiD6Uy13WybgVWJVyDQcjS12QLnviw5B4lXl709ih3eB4sFeg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzS6JTMjV/SczX2DKs9wzQe+wmVr7s0arFBr/x0/6e+QzC1Jnwd
	MsVzhlyGACEbHJoBq3tRgk0PdR0GR6lcasWkoKCiZrjlHInYYqL8P1YE
X-Gm-Gg: ASbGncsYxNx4xBzY3/FoeNcIfTgq5CqPhiQHgOf+2tqnmBGhjKMdpqXD7ZHWbGbAFBa
	ItcGApblSWeRriR6TN/b4wPbgo68JYVZIdSGSDhfwa+YRPcqlieuvt9xPb9zqjg5ypHFu37Gbhj
	uHWdCZmSnDCObrmh+hCnju7cLWk6a3idwynMmwKoEGIwOhh1ITAmoCXsuJoBs1RxRRU8FKTHKO1
	ulUEqj34S9ybNU8IPIdM8tJhjQNjpirDAgCL71erZ0c8UePMyERIUfbKqyUG0/xiHf2GU3PX0BN
	uI2ucJEqVOXtZYut/DnFhRBIWrlAp92K4nD5Xxw=
X-Google-Smtp-Source: AGHT+IHq6XcXyLVADx8RMzuVH5BPRhqzjkxeGqAjeZYBld0fa47RxN7jl9HZCkyGPvl7+TMeaaK4OA==
X-Received: by 2002:a05:6512:a82:b0:549:887b:253f with SMTP id 2adb3069b0e04-553a6535b3emr24943e87.51.1749669309866;
        Wed, 11 Jun 2025 12:15:09 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55384f3deeesm1408927e87.62.2025.06.11.12.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jun 2025 12:15:09 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 11 Jun 2025 21:15:07 +0200
To: syzbot <syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, josh@joshtriplett.org,
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	paulmck@kernel.org, rcu@vger.kernel.org,
	syzkaller-bugs@googlegroups.com, urezki@gmail.com
Subject: Re: [syzbot] [bcachefs?] [rcu?] BUG: unable to handle kernel NULL
 pointer dereference in rcu_core (3)
Message-ID: <aEnVuzK7VhGSizWj@pc636>
References: <aEmnv69zbkinkDVs@pc636>
 <6849c49b.a00a0220.1eb5f5.00f2.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6849c49b.a00a0220.1eb5f5.00f2.GAE@google.com>

On Wed, Jun 11, 2025 at 11:02:03AM -0700, syzbot wrote:
> Hello,
> 
> syzbot tried to test the proposed patch but the build/boot failed:
> 
> failed to apply patch:
> checking file kernel/rcu/tree.c
> patch: **** unexpected end of file in patch
> 
> 
> 
> Tested on:
> 
> commit:         aef17cb3 Revert "mm/damon/Kconfig: enable CONFIG_DAMON..
> git tree:       upstream
> kernel config:  https://syzkaller.appspot.com/x/.config?x=523d3ff8e053340a
> dashboard link: https://syzkaller.appspot.com/bug?extid=80e5d6f453f14a53383a
> compiler:       
> patch:          https://syzkaller.appspot.com/x/patch.diff?x=17de99d4580000
> 
#syz test

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index e8a4b720d7d2..14d4499c6fc3 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3072,6 +3072,10 @@ __call_rcu_common(struct rcu_head *head, rcu_callback_t func, bool lazy_in)
 	/* Misaligned rcu_head! */
 	WARN_ON_ONCE((unsigned long)head & (sizeof(void *) - 1));
 
+	/* Avoid NULL dereference if callback is NULL. */
+	if (WARN_ON_ONCE(!func))
+		return;
+
 	if (debug_rcu_head_queue(head)) {
 		/*
 		 * Probable double call_rcu(), so leak the callback.
