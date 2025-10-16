Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9233314CC
	for <linux-bcachefs@vger.kernel.org>; Thu, 16 Oct 2025 15:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760627827; cv=none; b=fJelNzXXSGvcgzr58gY09j/gdOQ5hqlNFMAiqo5YYimH2LEBKsj+OEdDKXRaAF82jesvtgq7BOYU0ZCSnwZHoIxR0jzZrFjQSpy7MS7rEUlxHaw408yodBCjPL2+I3joF1iXMC+HEdcNx8waqTej4mnj2QJ/zS33yiZ9Red1QV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760627827; c=relaxed/simple;
	bh=rqxB8fRZGr/vpRI0rlbG7eUIE0NetMIvAtKwGEP3Qzs=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Sw4oSCq60saMWBTskCsMgS2T+zizK3gh7eKPpe8MAAQKmC+WjKPpjqko8DAyhwP/TDDf/xPD3y4afedptvDE36WIdeLebhCLLmpyM2BndQueSaFZF4RyEdXL3ATgkjN8bni03EhbN1Q+mARtUc5xt2hIY/D3Ic3r1AroOkoMjbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-90dfda98b4bso302948739f.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 16 Oct 2025 08:17:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760627825; x=1761232625;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0YIEw4zjHFhmxiznPKTUuOgfVZrZ8eBhLOXiXO1y5Ro=;
        b=hg2tsfjMQnpZrtpfzbT7eten/jbbl7SpWn+pHa71TFk8Unuir1EMTkd5D1n8MerQHV
         BZgvcCe+v32LgkTuzrZ8mURq5oJuX75fJnoWpSBP1xuHQNv8oSxOyJJN3CfqpWfN0OPO
         jIR44MW7W7C+cISLhMldpNRucSSiTgAmvmLLbWbkzgXzdAA2YPB28LVjpejvZMOdGoh+
         WQIR01lk9k+r4AGpLLL/dj3Hzu2S/I8fVYuIwsluiaMwY+D226dww4P1iyhoZlRxbz36
         MWZtamHXfzpGAuLgI0CfeUU1+xKd6c5GH652DGUU8gfJ3Sei+B0PrMEsvfc2USAr41Py
         R40g==
X-Forwarded-Encrypted: i=1; AJvYcCXYsxyqxgL7npnYpt5R/X5UmUK+TFbWyjQFa0hIHsozgLMaSGUQUATiK5UF9LChmA29kxFD9fQjoh7VV70ICA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwBrhFaLIaB0ASSkeXsn0IsJp9NZhkpXMOyr4o38Ffdp5AW8yfI
	oqI0S5kcKWHObNXlN6PpdPQPyl09H2gVaOtGbKrUVb5YULEsbSrfGAAfgK+wYdQ2lzlShCFe9RE
	2eu3oTQAPlw0EnZmZT0jqVziX+sWyH130kr0JacuSpA1HaEtF80XqzUBGqn8=
X-Google-Smtp-Source: AGHT+IElJHTTAofewZGbiItx2fBhOAecgmEckdvr/T9JQW+qO2PL0cL5r0TQ4jMQI9MQo5vAFV07y+S3LC5seLXP5vWonwuhL/zE
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:156c:b0:42f:94f5:465f with SMTP id
 e9e14a558f8ab-430c5292301mr9370565ab.29.1760627825380; Thu, 16 Oct 2025
 08:17:05 -0700 (PDT)
Date: Thu, 16 Oct 2025 08:17:05 -0700
In-Reply-To: <68b09cce.050a0220.3db4df.006a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f10c71.a00a0220.361615.000d.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in truncate_setsize (2)
From: syzbot <syzbot+0d26e9339d135e85c6e1@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit f2c61db29f277b9c80de92102fc532cc247495cd
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Sep 29 20:43:52 2025 +0000

    Remove bcachefs core code

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10240734580000
start commit:   b6add54ba618 Merge tag 'pinctrl-v6.17-2' of git://git.kern..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=e1e1566c7726877e
dashboard link: https://syzkaller.appspot.com/bug?extid=0d26e9339d135e85c6e1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14309c42580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1198eef0580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Remove bcachefs core code

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
