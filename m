Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991D11C0DCF
	for <linux-bcachefs@vger.kernel.org>; Fri, 16 Aug 2024 18:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723832724; cv=none; b=RHtFMfS66G+A52XyL3TIQI7JYTKhqgMB7hsGdi9bgoBYfPnJn0ESaEeFWg5sokSfJwiSNzviaKimeDW4tx4U17NT/fjSBLF4Afyd+3dK1FkTfZGCpkcwXyIpceftLX6LD6M08Ajxu+4pWQI/qbGU4RcGeZw0dqDNqX1s32R/nss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723832724; c=relaxed/simple;
	bh=bLv3LE7xzf34CPEENcBo075k8UT1C4f+1hdgmseoSxI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SDs90qDUGn+uW5RLDO5qykw2Qn1XjTKA7uslmAcOUapSET1fcbknGR37kxNE2qT3gNavwuTURuT/e4Z9g8BoPiK8sBs7CXDpc049C9qxHPL7oRFOYaMVhshWgXjGrJu0Mt3TGeeKWSG/da0tTrf3RoIOUPM9AoaiB7oBZwOYsxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j28MxS6w; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j28MxS6w"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc658a161bso13014685ad.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 16 Aug 2024 11:25:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723832722; x=1724437522; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/7qvTYY149J1kqjtJQDvm/wIDojWO6TKOVvEvytD7Jg=;
        b=j28MxS6wbXdDy+WPoWPMGIwscvgIjFuT8SJ6cUFD+Dh5OwNcMeHzH0BGSgqbazCr+e
         NBNIOuDsXkJCFGQBjtk5I3hVuYN6oasOOgX2ssWCYIKnhAbCrdmNMatDA2ls55yCdice
         t/PcHRJmq5r0nos5soOoil57ogE/QI9sWsgRykb4LEIoudTsJgsvwsmaktITpbsfLxmk
         NUvTIpo5JMPWoySnpXjdlu7K+Q3UMR9osnTvjxNLbhtpjPeQWWL5S4o74yv9kITY5Dvm
         BT/P0ZzpcB32E2Rf1j02yw4n2DlRHkxMjmWyNkokFaScE9kaoPIakNItaSBdNC5KUazG
         snLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723832722; x=1724437522;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/7qvTYY149J1kqjtJQDvm/wIDojWO6TKOVvEvytD7Jg=;
        b=L0DfjLmy401mFVn3laLfvxi1hWCFV9l+FsmpM0V1HitQtmKiQE1uyCM5NX8Qw1iFAx
         n7DhnAiw6gppX3ka4u+Am/0T08R4OwZNAeAUq7dFPWdfb+oQ7iW6PpRYp76iRM6hWdcH
         ui4tRHkgrRJ/AkbzEQQMbd4xEu3er7ak1VsubIO5GMLKldVY2AF1NBMHIuG8XcSJ8n2M
         hN6WQidSSl6yI9iFrWgWWu6FLhn0Go6OfayxX1sks6qISN89wqpBm9mdAw5SCmy3XWzy
         E1xNMUsotGit1/8bhZfEHYyR8DPSOOM1FZ5t/wKp+AWdJtzu55qe/ZdnOh8ehOJu4EUF
         st1w==
X-Forwarded-Encrypted: i=1; AJvYcCUUi7lXqtR0H6hjs1QCkfhmFF+gICRiBSd29jcqJ9ybK57+a3xgOsUy22FVkr2sCV5PwbB/Nzvf2bMifQkh3A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyRxoYyDn9CRr9hKVdK1xgLRdwq+vs/ArkrqOYXuDohmGKKKwsI
	af64p7Q8Mlr3yXs43Zvm1NyP/37YDzz2oH3hyNPJUENQVFrY+ytedDWwz8stUlpOGZ1Y5hULU4l
	tzA==
X-Google-Smtp-Source: AGHT+IE2e/YxsAd0hQUtNlW5it4ebVJhZ0hecml1WwILxzhgYwa7yj6o8Ej/0Eo+Wl+5FZnC9XXt0MuZGrI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea11:b0:201:dc7b:a8b5 with SMTP id
 d9443c01a7336-20203f552f3mr2554995ad.12.1723832721695; Fri, 16 Aug 2024
 11:25:21 -0700 (PDT)
Date: Fri, 16 Aug 2024 11:25:20 -0700
In-Reply-To: <0000000000009ca899061bab0a49@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <0000000000009ca899061bab0a49@google.com>
Message-ID: <Zr-ZkD5wbcKhapom@google.com>
Subject: Re: [syzbot] [bcachefs?] [kvm?] general protection fault in
 detach_if_pending (3)
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+f4b2fbba4d8c2e290380@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, kent.overstreet@linux.dev, kvm@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Jun 24, 2024, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    626737a5791b Merge tag 'pinctrl-v6.10-2' of git://git.kern..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=117e90d6980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=53ab35b556129242
> dashboard link: https://syzkaller.appspot.com/bug?extid=f4b2fbba4d8c2e290380
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> userspace arch: i386
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-626737a5.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/03802640516e/vmlinux-626737a5.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/09b1b299316b/bzImage-626737a5.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f4b2fbba4d8c2e290380@syzkaller.appspotmail.com

See https://lore.kernel.org/all/Zr-Ydj8FBpiqmY_c@google.com for an explanation.

#syz invalid
