Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D345176227
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Oct 2024 10:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729852265; cv=none; b=T/TSl0KrYFATjVeN7HFM1je37ELJtUAmoa5zXy+wKSv7yMPrRmemLTqhTKWNZxp14QRPPGyPvv/R7TQWDSlX2lYoaDZvzrQGL7+zhEndiPUfF0DOZ5bXj7OExCe47DcShq+60FTV+Wcf2WQ8NMjAYktNRBL9bHqSheavCyglbIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729852265; c=relaxed/simple;
	bh=Ks9YukmsODd18DuIoqWPAwldy++arjEKcnYgqiDZk34=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=sr3LKuTYbqK65HauhmXYDMLmbn8gV3WkB21PQYApbtAFht6G59mIeOEqydgJJVG9QQ4/bFc8Cfgh1sKWb21yIWa6Efa3pmrDEFUAV0zX+TIXcadJgqmSGNz3g3n7mB0sRptmEX/cY0CTCVpsP2UcPW4t+wqiCtHvru6HfXbf/1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-83ae0af926dso182609739f.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 25 Oct 2024 03:31:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729852262; x=1730457062;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZSgMWLlIt9TfQivIQ3WnN+tiBQW0fVmjjbR6xce7TQs=;
        b=d1c7McZng5V2o7Q6+QYLHyycSyWZePgxXm/y2vNTX8CNNpR3HkaidzTUp5/vRHNieB
         3Z/fdCvm+GZ4qag/NqyuP1k1y/Sicos8kKkK8BfiGo7u8UqHcn5M9KhnKebYI80lXPch
         suAu25VPhWvXJV28wlexxtuckMltpV0a/XHvhBw+kh3AqEj3opduxVdPZyozJus7eFYs
         wrnyKRKZnV6O9wC94J2ADpiXtnYOUVZOMo5K9BqWGneRd1tBqYtPLty31zg+DsBtZ325
         m1peFRezEQ+9amMMbIFGbsqOZVG3I4BX6FhQCOxJs0LPKuihehWOjf7RXx+iIt2qT759
         V7EA==
X-Forwarded-Encrypted: i=1; AJvYcCXNERJbMlYyKZ1rJpI5d2dgac0BjTBsBt437DGyaWHZBBmUS/RUnIGjK0Ws7SaMzeZg2yyfNoliy0wa4HPuLA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8e+QSGR0tTLRetABGlR97tAuA+O9cOuCTdUBwHqxIc8YrOn6x
	hkGLPqE9ixs7BoVnwaZhcAInA/T9k3V+Wi8f+hLpMgvUGV1k0t7qEaZJmLwM4XzaA8JKkquk87e
	bFwa0NQa8T5iNgs2noQ/a6/zLwX+IVPk3O4PT8xcLM/RG0s+WERCXSmI=
X-Google-Smtp-Source: AGHT+IGo7N3Bcp4JM+Lb4k/uPu6Vy0AQ7J82f6oah50o+OjnMbX4jogd0YWlH8Khx90cKsfLfL9i+aNQWQcejvsFYejUdt0LfZrf
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12cd:b0:3a3:67b1:3080 with SMTP id
 e9e14a558f8ab-3a4d595c67amr93937395ab.7.1729852262534; Fri, 25 Oct 2024
 03:31:02 -0700 (PDT)
Date: Fri, 25 Oct 2024 03:31:02 -0700
In-Reply-To: <20241025100205.635960-1-lizhi.xu@windriver.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671b7366.050a0220.b833e.0002.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-use-after-free Read in bch2_reconstruct_alloc
From: syzbot <syzbot+9fc4dac4775d07bcfe34@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lizhi.xu@windriver.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+9fc4dac4775d07bcfe34@syzkaller.appspotmail.com
Tested-by: syzbot+9fc4dac4775d07bcfe34@syzkaller.appspotmail.com

Tested on:

commit:         ae90f6a6 Merge tag 'bpf-fixes' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11ab0230580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc6f8ce8c5369043
dashboard link: https://syzkaller.appspot.com/bug?extid=9fc4dac4775d07bcfe34
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10530230580000

Note: testing is done by a robot and is best-effort only.
