Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD5B207A0A
	for <linux-bcachefs@vger.kernel.org>; Wed, 12 Feb 2025 09:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739353744; cv=none; b=jflrHa2zyCsmL+8DVqLcsICXz10gx6OhZ6+NdjJToTQsGPahCgbQc6frnnw9LMI7DOvSDj1RCfurP6QuOvo7oXP1MBDUIEpn0Z1Tz682o1fyBqG0/PNa6XpYmKsVI04mgui77HWSSfBnqHY5w8R9xHyTx/6+TcxkEmBZS27jR8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739353744; c=relaxed/simple;
	bh=rkCwBPKPtJ49YZ4SFX1SLtCIPwcFJwzxFPxxODXwTlA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=dcSAp4GxtlxWYBE/wU+tZvwwpdsFG7nfE55no60ktNwthok3utwRadM20X+bcXeOEIs2jCLjWNv97oE0z3TPojgb6j40j9c9KhcD2kLE74nVzRKpvWfA51SXOOMKtD7Jw39qltXEoNgMrvYCPHqnBGsA4f+GxxZGHlJloR3vOSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3d14a3f812fso91002465ab.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Feb 2025 01:49:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739353742; x=1739958542;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Io45Eohejs+Fvr4vaR6agY2CweeHHv/VVIkUZcuyASM=;
        b=iXMt3Se4gwljbYkf4bRWUlRPLslySA93AuuYfTHm8J+jU8akt+5w4R4S7FrRwDr/VQ
         nWQoLNdgqmxUi1WYdFBUfayRwRVLDrseNG0rVpPa8J9PKdUSMCEFHq2/i1OeeG0/gNIA
         1mJBRZNnqpNUZL98HbomHopleA+lZWXSZYyllziW4B5fmLGLYAqfaZeqKeiyMw/hNlPF
         5aaQYWOtbRYRiE5NivvshsxaUKNLhkdFouLLGk+hr3ePRJCPyHfmJ4wFEAhN6zCnUogh
         quH6r9JynT+6004eH2ZJPFMi2JJ3LhEtLl41MyGUWfP7HglSRlMhLxmnXd8nGuKbajRx
         bj4w==
X-Forwarded-Encrypted: i=1; AJvYcCUl0BQTF3HneF4TKJR7m4fLlQD+hOPS2cE7N7el/qZRy+9pYtL31WlkjopGvrLD0rQvhsNJpmLyPzGqjGv8nA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8vGGkU/KtJ5r4WLGeOXlNcOxdIKd//5eSPw4uHUu/1VL6Mu+W
	E9HUiIaRcaZViL0OglJNGzKo7IjlklhndiG+aF4RqoUZ63JOAESdtqhvZlKbbj1Ez66svjnA87/
	Jxf5XBPm7w8ctJSn0aV/VctaqzWGFg/hkjrc76jN4nURxOLJVsohe5SE=
X-Google-Smtp-Source: AGHT+IHmzz7MH3fIY10rUZGar542sOj+lOZJTturqEGQw5yGoQNxbyXt3oX2g1mSJu7UbCOXups98TFKVPsi0BkfK4eUHSS2FCE4
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:13ad:b0:3d0:47e3:40bb with SMTP id
 e9e14a558f8ab-3d17bf4a445mr26670935ab.4.1739353741937; Wed, 12 Feb 2025
 01:49:01 -0800 (PST)
Date: Wed, 12 Feb 2025 01:49:01 -0800
In-Reply-To: <71A3E5DE-50CF-46B9-93A5-8A27C1817F01@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67ac6e8d.050a0220.3d72c.0140.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] possible deadlock in pcpu_alloc_noprof
From: syzbot <syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mmpgouride@gmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
Tested-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com

Tested on:

commit:         09fbf3d5 Merge tag 'tomoyo-pr-20250211' of git://git.c..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13cba3f8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c2347dd6174fbe2
dashboard link: https://syzkaller.appspot.com/bug?extid=fe63f377148a6371a9db
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=12f28aa4580000

Note: testing is done by a robot and is best-effort only.
