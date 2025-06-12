Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7BC29C339;
	Thu, 12 Jun 2025 17:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749748841; cv=none; b=Iq3HSA26vyXzNQtT1pT/z2hpnVoL0mSUKC3pre8GUdYFeku+0R6/vKU50z7vSaOpPgmAP8LJ8miYRfA69ltcA0p1kZkPiE78Q0jYb7Jm1GRfD/MuyZ2l1zzNWy40+EO+qCy95dnsQjW4ssaz9XIRxys5yql+fcqWl7nplYqh8m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749748841; c=relaxed/simple;
	bh=30OaNfhxOl1+JVp2Fw1Ld6tWGFD64189KykhYO04Aks=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=D4NYNoMqBK+Mmy9QatcdSbRJRgad5A/AhNN/D9VqG+LgK6dV4XL/n37/Vk78TyhAev3K/9qzMqhQug50ec7/KYcNUDrUWH9YNoABJ5DcfszxiuKH0jt2+J5lARmVeGAE2Or+IAN3mUomcxXpSCkDTQafTf7MFzmhiQlGW/IqF7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bjwC0vmC; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bjwC0vmC"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6fadd3ad18eso13314826d6.2;
        Thu, 12 Jun 2025 10:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749748836; x=1750353636; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:references:in-reply-to:message-id
         :cc:to:from:date:mime-version:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UPZIbm4XMI6Shq4UvXv6Rhb6fJc3PMgP94vsh6B69sc=;
        b=bjwC0vmCRQFUu80Hr70+FfRt5A7wl2Lr5L88sT8x8u30rCNgYyHoRr6Tl5MYYGPSvC
         mCw0OEzAoIQ7vZv6X48MGo3081TU4Mzh9iO8iXaEVb7/cTldfyUpdXw4aKGWrCbERFE2
         Wwtu4+l7jaCv1/S2hpphhOYDUC30jsqWza0yuT3gTLlXOKaanOGerV4tmO+iaw0//bGE
         ASepvZoQcI6VEcLjwo8MQW+jmqnEPP+rtK/+raOjZeocZrWUDVQdtoePkwH7OWYPKIld
         FJTK8HNPqAVT8nFzjTL3ouBOq6igRjj/F1jH5/2qdqbAAfWc9LXXRbN56gBgjHQK8oyf
         YdAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749748836; x=1750353636;
        h=content-transfer-encoding:subject:references:in-reply-to:message-id
         :cc:to:from:date:mime-version:feedback-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UPZIbm4XMI6Shq4UvXv6Rhb6fJc3PMgP94vsh6B69sc=;
        b=GD6jdeLSSQSjaqNRM8knJ51yb8cMIGSZLI6A2OJh71zhFGvpYr/BCYc7rZAtNj2WB0
         daAtMI4QoUKl3oKCIPTVsZFpeyHJ+Jcg3RdfIeH5gvyVH8YIMacXllfdqqz7GVIQSjVW
         JmgtSCxqHDhiDRad99/raFTM9tuWUtQmneohv8+S0Ax1zrWPek2CzfVbpODf19sM7v/g
         w6KFy5arhCwq+iOmF4E+NkM1XoifzqSi5b3IUNqaRu+N55Om2lPJW/P5mCr9RiD7KCpT
         XCX9JeGmNIv5i7sz+TDHX+ddB8LySiHkVtaAD/fndTrF/ZL0ggypVHM2iE9t1a9zZU6n
         XVmA==
X-Forwarded-Encrypted: i=1; AJvYcCUGdlNWEwjHwHFKmxNp2RWoblc1m7DxoPPJ9lnGsxJQ74ehyLuckh9gWQYbdE86gbyHwc4ureFbqhVBpiqs@vger.kernel.org, AJvYcCUfz/hJe0dYc3yiIntVx1oFQmXv5afmfa7MjfdiUYc0jL7Kd94ohzEkqM/vEQHZspjqiECL@vger.kernel.org, AJvYcCUipk0inzPyfAXMZEXtx0PduMVcWIxekYghk1qCUzcSpEatGV/J8bQpCcitmF5LWNduUSOIk0+btfysZsQtKg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyM809G3D8sB7RFgusEGRvn6T/np7c9tSA29KCwdlwBxpcXUra1
	I++H/bpufdMeFb0qS8cWmKz+4P++md9/YlTtEOVX7z8cGcvgmmb7nyub
X-Gm-Gg: ASbGncubppFI4AerR3D0qFXLTHJDyrnVeujbWfRwt7EiFfOz/m9wo08jt0oUBsjVyWF
	YGYTDRsaQihlW/A4w4fApfFG8IpdGR0CeGfv8001w30WCBZNyqoYHISWIlfKruFYP2AoHv8zbG7
	mPmHBATfMlAetzZDy3MeUMTYklinFw0TW+OdobHKdlYHhUWqR2adWTK+f9JBwaBBKCv22RHgWGI
	4mFCrGjT37Mm77SCYNdsLd+l8N2MvthUBi6j3JHkdLnT2skXnoreuC8nyOiRF7xmQ3OkimTw+zC
	kk711RerAps/RJsJSfqw5EKIZ/N8bIFmaI+j9dJ9leydDzCPy1lVLt3wt/MRE3l/i8Thke/nA7C
	nb0ZxnbfahS5lu0qpzGXfjOg13aHWhXsaGMWT42UkwY32dC2d8mqO
X-Google-Smtp-Source: AGHT+IHttlNlb5nIF2xhNPw/L8hssrtu2e31+YakH1e3Ja67V0k85kXBDZPC+uvrn7c/tWgIzYAk9w==
X-Received: by 2002:ad4:576d:0:b0:6f2:a537:f47e with SMTP id 6a1803df08f44-6fb2c38d62amr117505276d6.42.1749748835886;
        Thu, 12 Jun 2025 10:20:35 -0700 (PDT)
Received: from fauth-a1-smtp.messagingengine.com (fauth-a1-smtp.messagingengine.com. [103.168.172.200])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fb35b303a7sm12345696d6.36.2025.06.12.10.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 10:20:35 -0700 (PDT)
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id D943B1200068;
	Thu, 12 Jun 2025 13:20:34 -0400 (EDT)
Received: from phl-imap-16 ([10.202.2.88])
  by phl-compute-01.internal (MEProxy); Thu, 12 Jun 2025 13:20:34 -0400
X-ME-Sender: <xms:YgxLaJ46iDcG62uyqt_2PBIC0p3dt55zXoSbwRdzKWwLbjooIy2ubw>
    <xme:YgxLaG4FSV-N2JLWR1QgP8IMCnD-nYZwfOW3mJDvRip7JzBDrMcDJx86-Gp--9JtQ
    PqoVHb5GcmpArEGGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtddugdduheeihecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenucfjughrpefoggffhffvvefkjghfufgtgfesthhqredtredt
    jeenucfhrhhomhepfdeuohhquhhnucfhvghnghdfuceosghoqhhunhdrfhgvnhhgsehgmh
    grihhlrdgtohhmqeenucggtffrrghtthgvrhhnpeektddukeevudehkeelvdeugfdtteeh
    fefgkeeltedvveefheejheegieevffehjeenucffohhmrghinhepshihiihkrghllhgvrh
    drrghpphhsphhothdrtghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhith
    ihqdeiledvgeehtdeigedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgr
    ihhlrdgtohhmsehfihigmhgvrdhnrghmvgdpnhgspghrtghpthhtohepuddvpdhmohguvg
    epshhmthhpohhuthdprhgtphhtthhopehurhgviihkihesghhmrghilhdrtghomhdprhgt
    phhtthhopehnohhgihhkhhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepshihiihkrg
    hllhgvrhdqsghughhssehgohhoghhlvghgrhhouhhpshdrtghomhdprhgtphhtthhopehj
    ohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhgpdhrtghpthhtohepphgruhhlmhgtkh
    eskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdho
    rhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrgh
    dprhgtphhtthhopehkvghnthdrohhvvghrshhtrhgvvghtsehlihhnuhigrdguvghvpdhr
    tghpthhtohepshihiigsohhtodektdgvheguiehfgeehfehfudegrgehfeefkeefrgessh
    ihiihkrghllhgvrhdrrghpphhsphhothhmrghilhdrtghomh
X-ME-Proxy: <xmx:YgxLaAd8wIk9QL9eTtEt-T6LmvMM07LNgIg-wZ1yAPEH6m1EVeMJ0g>
    <xmx:YgxLaCKFukOPQ5_8v2juvW4Ujtx14O4unUjFuXKgWFzXGIx1welnNg>
    <xmx:YgxLaNL_ot0V5JwbLWTWP0dgZoHsrCn0oNpRi0RPBihW0s75oVDJsQ>
    <xmx:YgxLaLw0vEIQhTQ7psS_DQj8-GhuIIdANiHQt5tLlg6hiA12cIwF2Q>
    <xmx:YgxLaJLtcJniWXtrg3VJ9VujlJ31LC2c9C66QS2ibLKQifKRk2uXl9n6>
Feedback-ID: iad51458e:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id AE9032CC0081; Thu, 12 Jun 2025 13:20:34 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: T151d60db33cdf832
Date: Thu, 12 Jun 2025 10:20:09 -0700
From: "Boqun Feng" <boqun.feng@gmail.com>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
 "Aleksandr Nogikh" <nogikh@google.com>
Cc: syzbot <syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Josh Triplett" <josh@joshtriplett.org>, kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, "Paul E. McKenney" <paulmck@kernel.org>,
 rcu@vger.kernel.org, syzkaller-bugs@googlegroups.com
Message-Id: <112773d5-4056-4c9c-8a13-95056ed48c98@app.fastmail.com>
In-Reply-To: <aEqfySUeBHDbQ-96@pc636>
References: <aEnVuzK7VhGSizWj@pc636>
 <6849df90.a70a0220.cc01e.058d.GAE@google.com> <aEnuAp5w6QSoSu_M@tardis.local>
 <CANp29Y4d3de3cc9weuqHCw2sDMdtArOFz5B=783KZ4419Ux=Ag@mail.gmail.com>
 <aEqfySUeBHDbQ-96@pc636>
Subject: Re: [syzbot] [bcachefs?] [rcu?] BUG: unable to handle kernel NULL pointer
 dereference in rcu_core (3)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On Thu, Jun 12, 2025, at 2:37 AM, Uladzislau Rezki wrote:
> On Thu, Jun 12, 2025 at 09:42:32AM +0200, Aleksandr Nogikh wrote:
>> On Wed, Jun 11, 2025 at 10:58=E2=80=AFPM Boqun Feng <boqun.feng@gmail=
.com> wrote:
>> >
>> > On Wed, Jun 11, 2025 at 12:57:04PM -0700, syzbot wrote:
>> > > Hello,
>> > >
>> > > syzbot has tested the proposed patch and the reproducer did not t=
rigger any issue:
>> > >
>> > > Reported-by: syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com
>> > > Tested-by: syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com
>> > >
>> > > Tested on:
>> > >
>> > > commit:         488ef356 KEYS: Invert FINAL_PUT bit
>> > > git tree:       upstream
>> > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D129a6=
60c580000
>> >
>> > Is there a way to see the whole console output? If Ulad's patch fix=
es
>> > the exact issue, we should be able to see a WARN_ON_ONCE() triggere=
d.
>>=20
>> If WARN_ON_ONCE() were triggered, the associated kernel panic output
>> would have been at the end of this log.
>>=20
>> >
>> > Regards,
>> > Boqun
>> >
>> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D713d2=
18acd33d94
>> > > dashboard link: https://syzkaller.appspot.com/bug?extid=3D80e5d6f=
453f14a53383a
>>=20
>> FWIW the last time the bug was observed on syzbot was 100 days ago, so
>> it has likely been fixed since then or has become much harder to
>> reproduce.
>>=20
> That is even worse, if it is last for 100 days already.
>

My understanding is that the evidence shows that the
issue that directly caused null-ptr-derek the has been
fixed 100 days ago.

Regards,
Boqun

> --
> Uladzislau Rezki
