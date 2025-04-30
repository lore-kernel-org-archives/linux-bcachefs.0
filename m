Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0CD4298CB2
	for <linux-bcachefs@vger.kernel.org>; Wed, 30 Apr 2025 20:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746045307; cv=none; b=C09wj/S/+RzUw/WOaz3m0j6/0lXgQywqeKMhksfms0T8ezGrHcSrMGCSiivyeLLV8ZEko3Cq6bX5YVTMSKp/QpWcKlpM3pWZMkWqMJRjZdDcZJlz9jxVXhGU5ucUCK1ctgyxtZfQQhjcxfwg2BT4fK6vqN227/PAaAjCEvIhwm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746045307; c=relaxed/simple;
	bh=4/XsuOC0IPr5wwJxQNqjW0/dFud1iOENDHvvrETODY4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=hmK/1oL8PWyjdSsMbvWVlRNTDsLjoPO4G74vPlS5Ys4VayI/Ki3sabu/1PXzs6VFBCiIr55MXKj1HshZK5dksNBpA87dEECVhtkLWz10s3/M8wHyvfOaUbY/AXr+0+qbv6Mu4xXt6jD7ugafx6n2q+Z8c2gM1kRUqdH5dKKeTck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3d5da4fb5e0so2625035ab.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 30 Apr 2025 13:35:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746045305; x=1746650105;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e32cUp/b3R++mkuBmGQFgYOpYmO4M0/4mpbcHu13CvM=;
        b=R/kihkMXw26gkVWBJJEWUsN3TBzAGRTKRkJiEWA2fBpFv83xh6a2UWOM6qXZGaYE8J
         SI1pnpxzHJFLS7FPK/z3knDMlfDxTRN0pBuz8FUJmeCE1s8I5drjCAJFWgY+k6BHbsfl
         eWq5lwQU830K32H9kfN6DVgzB1Df5HdAPitgNPen7EjrvhDDole1zuItTgmXLu59Jlx7
         BzFdday/LRsJQR8dFSdjzjaF8gFkieCj6vZdhEXcM0U6eZklslrdRQ38E3sCdt3dNWzY
         p+a5LHKccwo0dlp8yR9MFHnu+jfyFvBsf40z99uet1iqZKNhbxSKXkLANLltm5XLxG0+
         xuAA==
X-Forwarded-Encrypted: i=1; AJvYcCUm1s+wTvraS0l6ERrYLamn4RgLRrS6xuu8u02RxCNCMUfa8TrpJwALTbsvDW2GVX3shAUtv5OyechTjAyqlg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyB4/yq6hQbXyAJ8JHy5s/zJmOrEEz73R6CLgZ/4bslUR58cfwj
	dZd0cPVFm4BWPU0P4PLwbRjzOrGPEDlzoWnST6NG+ORWOAQx09gZnM3wIkR7eEteH5tEWhqwZNF
	bVJ6dQy6NtzLeUiGjQoEbySW4dJQU1kGU0PrY005X99M2i+mE7gR/OIs=
X-Google-Smtp-Source: AGHT+IEBSWGzoRlHuLR+qdi2Ai+Wn5WkkdIy2n2sXyISJxwgZlUJfE+Jc92i1axHYa26ZBE0+rhXJtskgAwVShWtbKXhIN+Iz6ix
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3309:b0:3d3:fdcc:8fb8 with SMTP id
 e9e14a558f8ab-3d967fad850mr45222025ab.10.1746045304833; Wed, 30 Apr 2025
 13:35:04 -0700 (PDT)
Date: Wed, 30 Apr 2025 13:35:04 -0700
In-Reply-To: <0000000000003392c606179ddd1a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68128978.050a0220.3a872c.0008.GAE@google.com>
Subject: Re: [syzbot] [bcachefs] KASAN: use-after-free Read in scatterwalk_copychunks
From: syzbot <syzbot+8c4acf719c3fc41e8439@syzkaller.appspotmail.com>
To: bfoster@redhat.com, davem@davemloft.net, herbert@gondor.apana.org.au, 
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit bcf77a05fb3d6210026483703bcacb22ed961c99
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Fri Nov 8 05:25:18 2024 +0000

    bcachefs: Fix hidden btree errors when reading roots

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10dab1b3980000
start commit:   da4373fbcf00 Merge tag 'thermal-6.12-rc7' of git://git.ker..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=347f0ef7656eeb41
dashboard link: https://syzkaller.appspot.com/bug?extid=8c4acf719c3fc41e8439
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1579235f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1379235f980000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bcachefs: Fix hidden btree errors when reading roots

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
