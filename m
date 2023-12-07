Received: from cdw.me.uk (cdw.me.uk [91.203.57.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30FBBD57
	for <linux-bcachefs@vger.kernel.org>; Thu,  7 Dec 2023 04:40:59 -0800 (PST)
Received: from [148.252.147.228] (helo=smtpclient.apple)
	by delta.arachsys.com with esmtpa (Exim 4.80)
	(envelope-from <chris@arachsys.com>)
	id 1rBDgX-0007Dm-0s; Thu, 07 Dec 2023 12:40:57 +0000
Content-Type: text/plain;
	charset=us-ascii;
	delsp=yes;
	format=flowed
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.15\))
Subject: Re: bcachefs-tools 1.3.5 FTBFS
From: Chris Webb <chris@arachsys.com>
In-Reply-To: <3C032AF8-28B9-40D4-81D7-DB53B9432EBA@arachsys.com>
Date: Thu, 7 Dec 2023 12:40:54 +0000
Cc: Jan Engelhardt <jengelh@inai.de>,
 Daniel Hill <daniel@gluo.nz>,
 linux-bcachefs@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <AE9C6F86-E763-4C0B-810D-23311E4816BB@arachsys.com>
References: <rpq876s0-37r5-5099-6q6r-p3n36r7rr701@vanv.qr>
 <85FBC6E4-174C-46B5-8D7E-C7FE77124C7D@arachsys.com>
 <20231207081401.w44znpjbndiomrg4@moria.home.lan>
 <3C032AF8-28B9-40D4-81D7-DB53B9432EBA@arachsys.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3654.120.0.1.15)

Chris Webb <chris@arachsys.com> wrote:

> There's si_meminfo() for the /proc/meminfo information... and I think  
> he's already using that rather than mallinfo2() for all the values  
> formerly read from /proc/meminfo.

...or I should say, sysconf() in si_meminfo() for that information. For  
the values we're using, this calls sysinfo() underneath in both glibc and  
musl, filling out a struct sysinfo and then peeling off the relevant value.

Having read the patch more carefully, it's actually two changes in one:

1. Fix si_meminfo() to use sysconf() not /proc/meminfo. This is very  
sensible and causes no libc-portability problems. I imagine it must get  
called a lot in the fast path if it's a big performance win, so needs to  
be fast?

We should probably do a single sysinfo() call here rather than several  
sysconf()s resulting in multiple sysinfo()s to fill in a struct sysinfo  
for each sub-value retrieved, especially as we're filling in a struct  
sysinfo ourselves anyway.


2. Change run_shrinkers() to test the heap size from mallinfo2() against  
the host's physical RAM. This breaks on musl and older glibc - and  
presumably any other libc - because the heap size isn't exposed in a  
libc-independent way.

The current heuristic effectively assumes that we are the dominant memory  
user at the time, trying to shrink our heap size when it grows over 80% of  
the physical RAM. That sounds pretty reasonable for a fsck process.

The old heuristic was changed because it didn't allow for the physical RAM  
freed up because we start to swap. But sysinfo() provides total and free  
sizes for both physical RAM and swap, so presumably we could just consider  
the 'real' free memory to be info.freeram + info.freeswap - info.totalswap  
when working out the pressure? That also loosens the assumption that we're  
the only significant memory user at the time.


Does that sound vaguely sensible? Happy to send a patch if it does make  
sense and I'm not missing something obvious.

Best wishes,

Chris.
