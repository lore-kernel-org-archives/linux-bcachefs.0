Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B642F12CA
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Nov 2025 09:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762853464; cv=none; b=sc/VJz55AISw2Z+w11hcsbFOLKzLJpbXJKjUJdPRq7Tf1ewfsfMgck4ZRDSqRndOSkENn437+pYs/dw2B9i7+T3AYayPZICIQO7T1VxVaYj/u6S+y2dpVadhouF6YEfiZNM4Tjw5X6PpW6AsWWyqPBI9hyZ4au3oOz1eL43cJlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762853464; c=relaxed/simple;
	bh=Y6icNS0enP4Futo76bokaCirVhEX/sPcgJHr1uaOr+s=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=kbHyqbKCXFl7esED5p4k5yyvFIhVhaUUeGJ6mG6HIhY7iPWPelKdF4YpOdX5QxHpt0lpwVuYwbPYd85p28s3Lu2b5OTWu/uJZm53hGprui8kfWIt67j8dP/xTLbc8viLgpArcXDwFAhNEZuc3fnN1Akf0h9nL8C6vkJ3W/uCF90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-4330f62ef60so39970455ab.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 11 Nov 2025 01:31:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762853462; x=1763458262;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sI4tqzwWKxYYCaEx+/dzCMmBwjH59LLH/ABS+K1m3GQ=;
        b=Yh6GS/v6xPQG2tyE9Z8FTl1T9iuKcQ3Dri4eZh2vMQMlLvRZz9BdDq18porc1d5TNy
         Sus4VdKE0wv9F5f69KdGcPyuoAlU/9qYZFhuyC8dKhhHR16qRs/Jc//pWa1UebkmXBHZ
         S3kJPORi02CitewZTQ4IHYSDwM3aNaHC7N5O2O7k043wP7SHbRXWQoiO+M+Ztwy0+1qK
         soKeMQDXJaQpY1EawJ8b7YMCBrje0H72kR4+78E9Gs+bsQUFst8f8/X6PtWlllKHchaj
         b0wcAmvThCYBTwpMI8lB+FkBRVtOisQ4xcYplTXD2wKiuTsWM7yoVRdNnLe5CNraqclv
         SL+w==
X-Forwarded-Encrypted: i=1; AJvYcCVBO2ialTInGFV5zZZFBa/CrA9Axvh9E/N53jVCfPU1KCEPCJiZD9i5iMZyl9XgiPV8WMfe4sBAcW584cf5dQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxthHf5+NC8nQHRGbWdSOlxJYgCCzlODE+zSGcDJxlwj3n4oVqo
	Y12ucNMD1X1Nc7TF/PmDjQte/bIMLN5FDNoU5Td5XZyhduJQjNts1RNrmrmv05LH03EVtm6vq0+
	pcZQjLblAKrJNkm0taIAS3VT7I8rPosHv+SSa1PYicmEufOT+dTRxQHkNg4M=
X-Google-Smtp-Source: AGHT+IE6RpcZ/R5cig2gmWlq5MhiK2B0wT2WSYnM44Ls0SP23m6/df7vrDkDcXasvJGCTVyo6PfZN2uQlmmdYQd9NJZmcQp+Am0Q
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1806:b0:433:30e0:6f68 with SMTP id
 e9e14a558f8ab-43367e5a614mr127640895ab.24.1762853461982; Tue, 11 Nov 2025
 01:31:01 -0800 (PST)
Date: Tue, 11 Nov 2025 01:31:01 -0800
In-Reply-To: <000000000000bfd7970619112bec@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69130255.a70a0220.22f260.012f.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] WARNING in __bch2_truncate_folio
From: syzbot <syzbot+3d11e35eeafe176a6c5b@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 2744e5c9eb1a1090b5f61c955e934c70bfe6b04c
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Dec 27 23:31:46 2023 +0000

    bcachefs: KEY_TYPE_accounting

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11d40212580000
start commit:   b6394d6f7159 Merge tag 'pull-misc' of git://git.kernel.org..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=713476114e57eef3
dashboard link: https://syzkaller.appspot.com/bug?extid=3d11e35eeafe176a6c5b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15c2ef84980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=115a1592980000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bcachefs: KEY_TYPE_accounting

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
