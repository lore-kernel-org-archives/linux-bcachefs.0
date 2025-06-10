Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB27294A0C;
	Tue, 10 Jun 2025 12:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749558807; cv=none; b=GT3nf9UMsh3Oe6zcLGucxVSYMRrJSM/GDR2LG/SBzUVkKZjS216zxXLRWD/ccfHkms7fruDOb+smAiB+bZRHo9Y3jBij5JX7TQ0JVMq8jSxAMXsWD0VFsHdxmFUg3E1im09yokW5wjn8zgikOkdaSDB0bAkS77QfyKfG1bV/MhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749558807; c=relaxed/simple;
	bh=VBXxwUdvWl4c3ybjB11bxg1BGuuJf/PJMr+ZuovfPkU=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hkzjvHciAC4nkd5u9pMHi9uumZRhdjByJnCuRck0RcQerg3SEfJwO/NqiWNOhbFrJzkjTmkLrgM4WXHEEVhU4voscZwSkS49MYoqiK2/oM6YQkvB1wpFuFyEujfNMrjmDw96WxqPXXK7aeygr95uyDjeOis9agUgozzoSHqOcN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HL8gV4qm; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HL8gV4qm"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-553241d30b3so4969996e87.3;
        Tue, 10 Jun 2025 05:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749558803; x=1750163603; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JWtbQxxWt3t96n29V0cwm8P5yIMhIJ19w8iPYjVrbYI=;
        b=HL8gV4qm/HaGihtMIofTCImDM7I0ns/asBe2DpK6S3yJlHsDmY5c5+XApPh7bkRgt2
         J9BPQpAuIF39HwBmY+UrvpT+9M17OlvelUW7RvbKz/G2BQhsRDnhq+J6S1+qTe986zgx
         sF0Kvt2SGV3KFcUvnJlQ4a681JpKyu1SrkEVuAsDjQ5icKlUYzqcMj3ISyr0uCFxN+yL
         usCbWKSdDlq7+Lm62vh2cqpw0oiBnkKf9AViCYI6YqZhLOVJxY4Hs1A6hYECXPnHswtT
         GbS2YXAQ3DEC87Qu9VJ1BAbOqY+580rAhNkKvmhePWhwykqgcjag4hnLMRA5zQGgWh1p
         NGTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749558803; x=1750163603;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JWtbQxxWt3t96n29V0cwm8P5yIMhIJ19w8iPYjVrbYI=;
        b=WzEUJOb0eTmU3oXpBDCnXIBzDOuTSKYqChdsPL1M1OXpIHkPggJgQ252j+YxaqmW9i
         dygtdjY+Tndnvhh9IkgBEF+Vz85ZFiu2qtDRKActvqe7JdbGZg5aKP1jKdeH2LQLmexx
         Ac/t+2hrA9pf6lDXwfhFQ/Ee/TSxXI0KEUVnypP5gbyqRRo6AQQJI4lI0TNzPOOFOzgv
         6gSX5R0jqQwDN1rhhW1I1m4d/kqzcGGqiRcMjNEZ4y9Gm9w/h+FoT5ZHDTGOKMRIqwaV
         OufsdnD8eXQT3b9+rrNKkbX8PLgzMoTNMMuPjX8kBw1zNy+Oo1ESu1rVmtFmLOo5cMkZ
         4Fpg==
X-Forwarded-Encrypted: i=1; AJvYcCUDIdykdY2ENi+MCRYxwB3G+NgrnXPN7X3hRq+KJJJo2mXeJ4ArYdl9x5q685fanWN0VKCe@vger.kernel.org, AJvYcCVN7XATyCFKBV+FHU96pLUGk99qpKuj7ys6BO/0iP8pkWXJrgCQ/uIz3YzNbmsgE7KDNzI7rvECPxmo+l2O@vger.kernel.org, AJvYcCX79WaXwTcQ7LdY25EaPoQfi26UT36BmJ/xlHri+WuOLGA5rR2gURnM+SPqs/VdcQ4IQCJadO6fsLalzBCspQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzsXf6+FEwWHZOtoL4/HwTwylKYHUUciu8xXPsEd0vei+VMOQOI
	8Jy9aeNxZ//SvyxmBMgTQ97PaTn5ALKPJ2Pyrp0Y0uAJAS8CpFPODCHt
X-Gm-Gg: ASbGncuUnXUNL3z1+HQqW79S/L+Jqhx+hKaOuwzkecTnbnFN0lDmxtfjHNxkM7gNWIi
	ajtKIK00dI/JuoKOUCB2D4NS5pgdKxA1vuJnIsxCHBiHmhxaXLzPIJaXoMAFKIg5plw9EF6aO+m
	UKYwORQmbpWDrYRoUOZlXsetrT9E1qUV4Ky+JcT5TkDr8PXQ2IotCTvSNe3k5Jmry3KIs26p5VJ
	wnOvI5ozV2+JvmQXhVJe4qsh7GbKvZB4VlOdXISu5rboaZz4LWujN6dTw531Gs096mDEu1v2Gff
	sVNAp0azmZNO26YauvNdtrqKhgvAoFGA+9RzyqLwFw/5WdhUxoNd1YR+N+aVASnmYkuFEmicYrZ
	snrM7se3IkR0=
X-Google-Smtp-Source: AGHT+IGYxkHiIYIMoG1nj2TlsPmj/lNMnhDMR0HjbK7qS54Nga9uPN1rp4w8RNZdGM/yYk6KU7FAwA==
X-Received: by 2002:a05:6512:3d86:b0:553:2fb1:cfe5 with SMTP id 2adb3069b0e04-55366bd40fdmr4720338e87.12.1749558802750;
        Tue, 10 Jun 2025 05:33:22 -0700 (PDT)
Received: from pc636 (host-95-203-1-180.mobileonline.telia.com. [95.203.1.180])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-32ae1b0cd98sm15742681fa.8.2025.06.10.05.33.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 05:33:22 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 10 Jun 2025 14:33:19 +0200
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	syzbot <syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org, josh@joshtriplett.org,
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, rcu@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [rcu?] [bcachefs?] BUG: unable to handle kernel NULL
 pointer dereference in rcu_core (3)
Message-ID: <aEgmD6POgqn-jUH1@pc636>
References: <67a2b20a.050a0220.50516.0003.GAE@google.com>
 <9694d40a-072e-47c2-a950-3b258bbe04f5@paulmck-laptop>
 <jzknqese5idob37wxgclq7ptxnsd66qbqkxtjpjormymsrwv2j@xjum5exljlh6>
 <aEXVKNVLI3VQInSc@pc636>
 <13d5ecd9-3e9f-4593-b300-9141941a29cb@suse.cz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13d5ecd9-3e9f-4593-b300-9141941a29cb@suse.cz>

On Mon, Jun 09, 2025 at 08:28:56PM +0200, Vlastimil Babka wrote:
> On 6/8/25 20:23, Uladzislau Rezki wrote:
> > On Sun, Jun 08, 2025 at 11:26:28AM -0400, Kent Overstreet wrote:
> >> 
> >> I don't think it's that - syzbot's .config already has that enabled.
> >> KASAN, too.
> >> 
> >> And the only place we do call_rcu() is from rcu_pending.c, where we've
> >> got a rearming rcu callback - but we track whether it's outstanding, and
> >> we do all relevant operations with a lock held.
> >> 
> >> And we only use rcu_pending.c with SRCU, not regular RCU.
> >> 
> >> We do use kfree_rcu() in a few places (all boring, I expect), but that
> >> doesn't (generally?) use the rcu callback list.
> >>
> > Right, kvfree_rcu() does not intersect with regular callbacks, it has
> > its own path. 
> 
> You mean do to the batching? Maybe the batching should be disabled with
> CONFIG_DEBUG_OBJECTS_RCU_HEAD=y if it prevents it from detecting issues?
> Otherwise we now have kvfree_rcu_cb() so the special handling of
> kvfree_rcu() is gone in in the non-batching case.
> 
Not really. I meant that in a call_rcu() API there is no any check if
a passed callback which is executed after GP is NULL. If so, we get the
bug about about dereferencing of NULL pointer.

Since it is invoked by the rcu_core() context, we can not identify the
caller in order to blame someone :)

As for batching, we have a support of CONFIG_DEBUG_OBJECTS_RCU_HEAD. It
helps to identify double-freeing and probably leaking.

> > It looks like the problem is here:
> > 
> > <snip>
> >   f = rhp->func;
> >   debug_rcu_head_callback(rhp);
> >   WRITE_ONCE(rhp->func, (rcu_callback_t)0L);
> >   f(rhp);
> > <snip>
> > 
> > we do not check if callback, "f", is a NULL. If it is, the kernel bug
> > is triggered right away. For example:
> > 
> > call_rcu(&rh, NULL);
> > 
> > @Paul, do you think it makes sense to narrow callers which apparently
> > pass NULL as a callback? To me it seems the case of this bug. But we
> > do not know the source.
> > 
> > It would give at least a stack-trace of caller which passes a NULL.
> 
> Right, AFAIU this kind of check is now possible, previously NULL was being
> interpreted as a valid __is_kvfree_rcu_offset() (i.e. rcu_head at offset 0).
> 
> > --
> > Uladzislau Rezki
> > 
> 
