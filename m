Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2062422A804;
	Thu, 12 Jun 2025 09:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749721041; cv=none; b=IiWP0IqqMP/Mbl1iNI7yq7u0S9RzIz+E+PMimYbpBw+xfqEOmKz7vkO0qW/E4mHaJYP1CrBl3sUUOzMGzKca5JDEqWWKHxw92H/ogaz4+J5b95MLENftoAVP8VNNZ1+t+ZvEUh25t0tr5xwFCxwDY1T044K2AnRC6aplMu1Vzzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749721041; c=relaxed/simple;
	bh=VKQMD6iP+0w1E2dffmvUxlnEMT19ZCyMucFZHtYeZnY=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y43or5WG0TjALxiHbU4TctPzNgiapulXNK5y5XVDQ1DZkOQfqKj3puWZtJg4lQ7XYmEKB6+NNaVWxxENHkVGifvFEkZu3CIvF+c6LjnMtAp6ZV2LrwJUuTB3qLFYXi2Rxom97Jn7uSsrSF7rvLkRTJ8U1z9koCFhD7fmymFjNnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NN+tkTww; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NN+tkTww"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5534edc6493so809210e87.1;
        Thu, 12 Jun 2025 02:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749721037; x=1750325837; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Xk308O1KlvA6k3uBQDw8z50KFvPVgd1NjWS8ld81/fk=;
        b=NN+tkTwwmEKFmbe8JXpuOrcKtmTgld6iZkQsUYxHtKhmyiYaSAjZItgDaQoHss7W87
         U9IhX1DWYesSPc7FS1OzJSXxfoAVG+3f6FVqg0CJpbELMWgoYHEPOoohkY+mRRBsAXs6
         lzLCQcLgImvbqiobT9adUZ+pSsyY/HouNAy4io3hWc805Ivoqy0SDxq+YdaKMhAPR09M
         HL1njIjBhUO2eYYWT7V/KerdcR4RDyoDAs2vLqn7xYHfMvt13OOFQAO4b3g0EuJHiN41
         3rnQpbjptIruHt0yRmEU+Bn+e8JZWrdi9SFmX/EXPlur2ppJXTYVUP06R6eQhffWxhLR
         3hfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749721037; x=1750325837;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xk308O1KlvA6k3uBQDw8z50KFvPVgd1NjWS8ld81/fk=;
        b=hdmGOL2GnyYihzjl0C6iR5NRECRUiGdqQle7Q6w12/ypQ/AkSiKq7LcB85VXKGeHJI
         SjM7AAVHS015HFs+1IyYG0Uxcxk41yASJ+3g35dmAp9naU0spy2lKLSi8bUjn3fIzQoI
         oEiebNZzCaZ44tt2vS5ajdOmluFW9JFsIADE4skVLrpAqaxBfKbDF//1YplBwU05bPD0
         1sJXOkQIsVQyDLshXRLt5xfFGj7pfddXhy6xoB0i7uCMK+n1dMUqYbA5gqh4kuya40ri
         zFeetfauCNthUjddSjxfsh9DaLpCufw91AE+AjrK6HhMj/gUBsoLXyzSodpjHjy6gv+d
         8kZg==
X-Forwarded-Encrypted: i=1; AJvYcCUKKyiBSfi/yqKQ1S0AJV3Te4vA6Fg9tjR+lqdcZFSrXNJeCCNH9JrfIM5A76B7NPLOSqIsK4/3c+vDx35E@vger.kernel.org, AJvYcCUaZbdhWl27u7crGDBnso2w1VBmxqoqJeocg4NW2nNom/qqfmO96S1qp94j3HkGfoJjf6Pe@vger.kernel.org, AJvYcCWuKDBbDpsT3dU4A5IayCEo5AGxqV2oT27M4xwF/SDGqbssZZtSdzZ9smdxKiERhrIF6Zq30gfW9NjibhsUSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzLXon9iK+HW8y6h+n0VJxYAlskWaXCqA+V0yJyy0UmrK5/YW0Q
	Z9SV5o94tOnBOtY4zO5JjABTDudsKlOkbU5HSYSSvHBNiEKXzu8mkVP0
X-Gm-Gg: ASbGncuebTkJZSLHxLumEs/jmdd/rWOFgXiZ7v8VV15iOrlkMPRchQUQSRqRixyBvfl
	pN85G5eYhwpzpIyGiJqGQdUxzvaorhZwUL8EjxsSNkjAfBSHl0Q9tRV441QUtdDfurn3flcqKzV
	0N+K8bmmRc5fkiGkXD8f0zb/v4+Eul4t/P9Qeap+lORNPH865r6xSfMNDN32g+NZ4Hklxpn4IG9
	TSpJMqupXaa/+HmfA3U1RVGU6hLGcFQjtz3dpLO+XDqKQo2PhZGO48y0plNtuPrUh/xFJqVz0hS
	FcgF6wcyCF7u7zexC5lgDWvCaSIA/gJscw7evmn6zGpeOunRnIfFNIZRS6Lj2mUCmqiPqkLWcTP
	WSqKzdrk1ylA=
X-Google-Smtp-Source: AGHT+IEj5f77EREUpZ5E8w/EotPyfdIbWYVJo/+X7KstcTDOFCPPy6sZX4ZtpEWDZ+ZUxCfqDqiafA==
X-Received: by 2002:a05:6512:3985:b0:553:5d00:be86 with SMTP id 2adb3069b0e04-553a55f7c07mr835838e87.41.1749721036987;
        Thu, 12 Jun 2025 02:37:16 -0700 (PDT)
Received: from pc636 (host-95-203-1-180.mobileonline.telia.com. [95.203.1.180])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-553ac1ab650sm52500e87.91.2025.06.12.02.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 02:37:16 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Thu, 12 Jun 2025 11:37:13 +0200
To: Aleksandr Nogikh <nogikh@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	syzbot <syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org, josh@joshtriplett.org,
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	paulmck@kernel.org, rcu@vger.kernel.org,
	syzkaller-bugs@googlegroups.com, urezki@gmail.com
Subject: Re: [syzbot] [bcachefs?] [rcu?] BUG: unable to handle kernel NULL
 pointer dereference in rcu_core (3)
Message-ID: <aEqfySUeBHDbQ-96@pc636>
References: <aEnVuzK7VhGSizWj@pc636>
 <6849df90.a70a0220.cc01e.058d.GAE@google.com>
 <aEnuAp5w6QSoSu_M@tardis.local>
 <CANp29Y4d3de3cc9weuqHCw2sDMdtArOFz5B=783KZ4419Ux=Ag@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANp29Y4d3de3cc9weuqHCw2sDMdtArOFz5B=783KZ4419Ux=Ag@mail.gmail.com>

On Thu, Jun 12, 2025 at 09:42:32AM +0200, Aleksandr Nogikh wrote:
> On Wed, Jun 11, 2025 at 10:58 PM Boqun Feng <boqun.feng@gmail.com> wrote:
> >
> > On Wed, Jun 11, 2025 at 12:57:04PM -0700, syzbot wrote:
> > > Hello,
> > >
> > > syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> > >
> > > Reported-by: syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com
> > > Tested-by: syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com
> > >
> > > Tested on:
> > >
> > > commit:         488ef356 KEYS: Invert FINAL_PUT bit
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=129a660c580000
> >
> > Is there a way to see the whole console output? If Ulad's patch fixes
> > the exact issue, we should be able to see a WARN_ON_ONCE() triggered.
> 
> If WARN_ON_ONCE() were triggered, the associated kernel panic output
> would have been at the end of this log.
> 
> >
> > Regards,
> > Boqun
> >
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=713d218acd33d94
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=80e5d6f453f14a53383a
> 
> FWIW the last time the bug was observed on syzbot was 100 days ago, so
> it has likely been fixed since then or has become much harder to
> reproduce.
> 
That is even worse, if it is last for 100 days already.

--
Uladzislau Rezki
