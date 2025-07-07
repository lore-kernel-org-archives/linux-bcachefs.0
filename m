Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A831D416E
	for <linux-bcachefs@vger.kernel.org>; Mon,  7 Jul 2025 12:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751889608; cv=none; b=dlKDHBS2iUWuRgHInO7r+4Sx1rUW/bxayaHkLotnQJnxWq5PfZmAltuJeO4+q5KcUEYbSprpZsbCInC79mvtUccxfxxbE5dHhQf7s5UrmIW0t1FMWiwzcY/iMN0aHfO06GM+XCVKWFID+IUdc423f5qX1LEVaw7FMPD796A4hJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751889608; c=relaxed/simple;
	bh=sR5NzZd6gB92D+YYUhDZHN28rfytV6FGqZQRcztfPFQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=db/UYqdQU89utUV996YypoGizSWbDUtHX68iLNOBluYLCWZPHmerj4gKbF3h9EtHKBfx5uuG7afpp+aIxSElo+hU7W3/OeF0fm6lMzxBifaxntqZDQPyzKDVZ04qDkZ6EUFeBTruYj/kBzK9TBPjRWWncyRdPjr4fS+f30bt29o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3ddc0a6d4bdso29756455ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 07 Jul 2025 05:00:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751889606; x=1752494406;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MG/BFrGeNu2zrolHFTcPIfc6coVJaiqjc4KfS7f00Z4=;
        b=nsxy8boYbJUNiRxfqDft+X5Dv4tutek5b9/lYwTsekrrHuWKECXGpM27dovUgBrz2f
         rS9NuG764X+MsD1gGRsMt8iZTAQaAy+LnMDEbTnd88JnmdSsGh1xohnaYvOVspGd6gIk
         Yrhopm+i2l/DnBtgh+6nuEmpEE/luw7OEYfrjiDkAHoAtELRzEJjINrw5N9/SY+3wMhQ
         z55otIBLczsBj0wGtufOQk5EvOvdXFhZpMJr8C2sMqVfaXsECVP+Hljs0hWzbM1Jmr4M
         pDULp1khHvGwP4BS26adp9Xbh/BSJDnxd7xZo7lh0EF7mqRY6Dlbubxpt/2UTq2DftqJ
         85Bw==
X-Forwarded-Encrypted: i=1; AJvYcCUynLFiVDT908/lnwSLMe0IQL5M01H8LxKrH0cqGgge8ggSFJFvWWXYqSoUrOTNtvTW+k9DK8wv/XWAzeUedA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywwe6yHV2rNmxyO02KzY/dqzbgqsZv3YpRCcH2+jly45c+Md+u5
	0nAHaj/tHYmqCyuHAi7jrBuzWPGx4q4KDBthqYq5/amvaaKMlJyHBWZxY0BvDUZX+6d5LeVLaEm
	nw2Ab6aFEyVhJUN0k3ci2aNs9ysjhrtERJxtooNwT/aul/qDQmRj8rrhMM2g=
X-Google-Smtp-Source: AGHT+IEuiO6NN4/MHaaUcmlU6EEXItxKrtn2LFDJXr1h+3rZWUE7rs1UVj+Y/EJQ7GuyDWCSIoQ135BiVSZvIOe7v2H+OWivZaSO
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1f12:b0:3df:3ab2:cc7c with SMTP id
 e9e14a558f8ab-3e1355658bemr96154485ab.13.1751889606077; Mon, 07 Jul 2025
 05:00:06 -0700 (PDT)
Date: Mon, 07 Jul 2025 05:00:06 -0700
In-Reply-To: <6853f202.a00a0220.137b3.0005.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <686bb6c6.a00a0220.c7b3.0084.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_trans_update_by_path
From: syzbot <syzbot+210dfbddd64294066983@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit d21262d4e35d448cbc80092c91f04cc0a5f2b0b4
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed May 28 18:26:33 2025 +0000

    bcachefs: bch2_dev_journal_bucket_delete()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=100a928c580000
start commit:   d7b8f8e20813 Linux 6.16-rc5
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=120a928c580000
console output: https://syzkaller.appspot.com/x/log.txt?x=140a928c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=72aa0474e3c3b9ac
dashboard link: https://syzkaller.appspot.com/bug?extid=210dfbddd64294066983
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=141a1f70580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=121a1f70580000

Reported-by: syzbot+210dfbddd64294066983@syzkaller.appspotmail.com
Fixes: d21262d4e35d ("bcachefs: bch2_dev_journal_bucket_delete()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
