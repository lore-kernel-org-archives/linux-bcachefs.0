Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5229C4A1A
	for <linux-bcachefs@vger.kernel.org>; Mon, 23 Jun 2025 01:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750641124; cv=none; b=YTzCzUSkUeFdDJnQ1YMQp/mxp1zD+2tAxUeQNGl2KlMnaKKLABMIy7nqp7sn9wKTXs2bDa+BnMiKLod+CQ1UhkAb/jfuUhTt9jBjlNidehclVXOZsz/4pm0GDrdz9MoeHpls9Zv5NqKh8FTnkSRV9KzzI131GVQTKpFHtSY4oJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750641124; c=relaxed/simple;
	bh=fsWRZU5pf5z8uYUewMpFhrgI0i5m6viw8lXsaI7KVW0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=IjkCBFjq/Hs5MP1VMzSfSbXAHZl7flNIq1JgKuMsx9oIcElIEQ0AWPmD6z4QPh/IT+Fw9PAUz7xy9tXQw4PMZrsap6di0pbJ+7GwBwCRq5xVulbgMDxDZSo4IcH8plGlpdp+ERL2Blm7/syZaaRMS5da60uO8BkCXA1oNaFKNxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3df149301fdso19226325ab.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 22 Jun 2025 18:12:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750641122; x=1751245922;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hB1qLRr0lfQzkkvkr2ChQlwMXTY1B7wcKeYfhbrbcCU=;
        b=TSdg9ZiLiP5j4O+MXlVOjknQPV4gmTSCRhxCRuBBggGCStmhaJo6bnmOs331Sg/l5O
         4L42XKxCwhkDeQRBxI1ypGnBKTt2J4Xe3Hya6K9zV2eD1z4OPYQdYx4ZHXrsCQuo0w8Z
         y/uV9RtJ4jP7aiCLcP1aKTtiO3oJTqEzxOz9UxCLn/cFrpssQyInmpiNf0r8waM0uttZ
         utYHOic2VLeoc9X09MfnCId2espqa+Hv8EqKS71cJo8C/PEyGs65jBIapFznkr6X7hPQ
         iVjdyy9mtozsAXfutvo1dtNFRba3rJA/UatpFthhVGMdZ79ubp4XIWWjELvnqFgRhv1T
         zWew==
X-Forwarded-Encrypted: i=1; AJvYcCVqNplA5js+6CE6OMu7ew8WJL2qUU7g6/yablq4+oCs0OmzEBcGVtTkKC8CkqNWLOWCHP+uRMY2L5cfjJWVQQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzv6YWo2zsxdrit2B6zjlnUXkPc8DCmhxjymCET/ZPdoeJaA9w+
	VE8humFN65hJut8eHTgBT4FgG3wxbRsPi94cQgHYNwm7AVC5Cz7thY+mibyV0SmDS1VLWn5JE9S
	J1Z32LWmWwh8h6w2IagpJyr96u+pyWVV5VLnYbX6or4JPLKkzYtnauzNY9Xk=
X-Google-Smtp-Source: AGHT+IGcFGUShXy8AwQ53b5N5UGyXN11GO6CMjK4kK159bwd6+orYcGrBcGHb3nl+7pWxqwz64PcssYAb73WhKk0U7icHJmq08W9
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a2e:b0:3dd:cba4:bfec with SMTP id
 e9e14a558f8ab-3de38c1c00cmr122541535ab.1.1750641122457; Sun, 22 Jun 2025
 18:12:02 -0700 (PDT)
Date: Sun, 22 Jun 2025 18:12:02 -0700
In-Reply-To: <68209eb7.050a0220.f2294.0035.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6858a9e2.a00a0220.23ad68.0004.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: use-after-free Read in bch2_checksum
From: syzbot <syzbot+7d5c34b9ec9fe139fc0c@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit cd3cdb1ef706a1ac725194d81858d58375739b25
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Tue Apr 22 13:14:19 2025 +0000

    bcachefs: Single err message for btree node reads

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=127d5b0c580000
start commit:   d76bb1ebb558 Merge tag 'erofs-for-6.15-rc6-fixes' of git:/..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=b9683d529ec1b880
dashboard link: https://syzkaller.appspot.com/bug?extid=7d5c34b9ec9fe139fc0c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=123544d4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11870768580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bcachefs: Single err message for btree node reads

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
