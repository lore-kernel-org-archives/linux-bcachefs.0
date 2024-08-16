Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13901C233D
	for <linux-bcachefs@vger.kernel.org>; Fri, 16 Aug 2024 18:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723832627; cv=none; b=R4H1LwKNO1bvM79VSZxak86fdMd0T8uHWPFEQnHhdMqftS0D40x2Urpo693IUVC0r0fh3aCXfkYlvvLayqG5cEnU1jEd8IamI8oKVKiyTblqDhcztT3JLJ5GTRWwQDk932l2S1tq35n8uk+MuwgCR51ykWoFgXumygpY1tYG520=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723832627; c=relaxed/simple;
	bh=kQ1Uus7lOLPKfEI1znCUipAS8W09PYgHvRFbSeVUxQg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lfJbgduUGIPQXaVcGz/MD84mlE/Z4X1T6E6c8ntwenGVrp5dMNKG5UGCUqvg67MRPM7joXDK4mBfljJez6oLiXVzzfjTronszP8yuB7Jr7+Eb1UBYaLp8Hw5mlXspzEEZuqtRqE1uqzCh5YmyBSPRkWZ6F7y1GNUh30EEyHfaFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mn08UjU6; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mn08UjU6"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a23a0fb195so1828984a12.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 16 Aug 2024 11:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723832625; x=1724437425; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=05nSFmbx6P/1DfD7+boXGyw0DEDSw8F82FYswNLhYr4=;
        b=mn08UjU6r9hN08F6IrD7U5clqCKPyp8RdHTmwIQ3pL/A9tFeDMXujYEeg2V+sgRNzx
         C3W/NWYzd0uM9KWAU6//GF77JB2B+vmD3Lpn/m7M7RKQ76HCbEoQWZ/9GdXVd3cUqu14
         FCPqrnDwxmjnHhHtGYKjD/TdnIdwU7rs58pFSFxvBOBO/rU3muyj1biA/tPlydnZoxuJ
         xqwGPKPXuVcm1aD7/ADXSmlEJhawZVm8fAyoei95QyqHy0VvZfGq7ch5dIFkVRjx638K
         WbDxmdztga5VOVk84l9GhW0nWX1ZEaKOXs+CeyXrUeLv+7Ge1ynmO3evbAm7PVL5Ig1+
         eCuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723832625; x=1724437425;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=05nSFmbx6P/1DfD7+boXGyw0DEDSw8F82FYswNLhYr4=;
        b=ua132fVGpW+1bcih/lcyrWWpwlRmUs+gGxwNmKOXD2mjHaW6ZXy+Df4v4hlYsTREKP
         zMqS8O1nVxD8u0EY6seedWYIZ+r9j9CZzhfWgUzSXoMul5gf5QhHBjLt2kDZ9kb2i6F3
         4ZboqQSLVvstmD/3rA+cgo8KL4kKd5tgih/sCaqB6IpearQkiC1NXCDeU+FzMb0PL+Ks
         LZCaB+lYhxfSQqsIjcfL6u84duX+EWxd8ofEFWLQKq9ghTUZQuNJlZuH2UFx3HDF09RB
         iGEUjpSQt1OFbD6mJ6ognYteVRMXJKs+hHIt54Q2Y/SqzuFM29iyZUOMWhvKkc21h0O1
         BCag==
X-Forwarded-Encrypted: i=1; AJvYcCWFzUrCaEZyw55Ok+c0UCxSQhSb3jF3mnf+hSDjVklXIBOdAHRjtzg3eSdbZoaMlJpc/u0P4pueMqGmdqet2hmrqd2iNIvG+WN++pOm3Oc=
X-Gm-Message-State: AOJu0Yzvk56+WtBb1QUcKgOXrfLfzUtgbjiwWJI9ZNvLtgtTWFyBaVQm
	nAOyxRJ+g35/yyUeu8EuWMlgflggpiCSMjiGqlEbcYyTJyTRJFvu2FgpmDqMNi4D2HBzrLDlPA3
	lIQ==
X-Google-Smtp-Source: AGHT+IE9H5LQQCH68NcdXMmYnIevmE/u5gJozQKiFZVITwrrnrd7MOM5/NVJLVxUdZgmbRbmnPYElRigQGc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:60e:b0:75d:16f9:c075 with SMTP id
 41be03b00d2f7-7c97b8222femr5928a12.9.1723832624835; Fri, 16 Aug 2024 11:23:44
 -0700 (PDT)
Date: Fri, 16 Aug 2024 11:23:43 -0700
In-Reply-To: <000000000000d258a006179e07df@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <000000000000d258a006179e07df@google.com>
Message-ID: <Zr-ZL9X87N6XhE60@google.com>
Subject: Re: [syzbot] [bcachefs?] WARNING in srcu_check_nmi_safety
From: Sean Christopherson <seanjc@google.com>
To: syzbot <syzbot+62be362ff074b84ca393@syzkaller.appspotmail.com>
Cc: kent.overstreet@linux.dev, kvm@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="us-ascii"

On Sat, May 04, 2024, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    3d25a941ea50 Merge tag 'block-6.9-20240503' of git://git.k..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1143ae60980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=45d8db3acdc1ccc6
> dashboard link: https://syzkaller.appspot.com/bug?extid=62be362ff074b84ca393
> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> userspace arch: i386
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-3d25a941.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/49d9f26b0beb/vmlinux-3d25a941.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/d2c424c14fff/bzImage-3d25a941.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+62be362ff074b84ca393@syzkaller.appspotmail.com

See https://lore.kernel.org/all/Zr-Ydj8FBpiqmY_c@google.com for an explanation.

#syz invalid
