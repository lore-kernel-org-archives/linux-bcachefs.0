Received: from cdw.me.uk (cdw.me.uk [91.203.57.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 42D5710E3
	for <linux-bcachefs@vger.kernel.org>; Thu,  7 Dec 2023 00:24:03 -0800 (PST)
Received: from [148.252.147.228] (helo=smtpclient.apple)
	by delta.arachsys.com with esmtpa (Exim 4.80)
	(envelope-from <chris@arachsys.com>)
	id 1rB9ft-00010M-JN; Thu, 07 Dec 2023 08:24:01 +0000
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
In-Reply-To: <20231207081401.w44znpjbndiomrg4@moria.home.lan>
Date: Thu, 7 Dec 2023 08:24:00 +0000
Cc: Jan Engelhardt <jengelh@inai.de>,
 Daniel Hill <daniel@gluo.nz>,
 linux-bcachefs@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <3C032AF8-28B9-40D4-81D7-DB53B9432EBA@arachsys.com>
References: <rpq876s0-37r5-5099-6q6r-p3n36r7rr701@vanv.qr>
 <85FBC6E4-174C-46B5-8D7E-C7FE77124C7D@arachsys.com>
 <20231207081401.w44znpjbndiomrg4@moria.home.lan>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3654.120.0.1.15)

Kent Overstreet <kent.overstreet@linux.dev> wrote:

> On Thu, Dec 07, 2023 at 07:53:29AM +0000, Chris Webb wrote:
>> Jan Engelhardt <jengelh@inai.de> wrote:
>>
>>> With glibc 2.31, bcachefs-tools 314ce7d (tag: v1.3.5) cannot be built:
>>>
>>> [   30s] linux/shrinker.c: In function 'run_shrinkers':
>>> [   30s] linux/shrinker.c:72:9: error: variable 'malloc_info' has
>>> initializer but incomplete type
>>> [   30s]   struct mallinfo2 malloc_info = mallinfo2();
>>> [   30s]          ^~~~~~~~~
>>>
>>> This is a glibc-2.34 specific feature.
>>
>> It's glibc-specific too, so it'll break building the tools on on musl
>> distributions like alpine and void.
>>
>> I don't remember compatibility problems with musl when I last built and
>> tested a few months ago, so probably a relatively recent and localised
>> regression?
>
> yeah, it's a change Daniel made to speed up memory allocation -
> mallinfo2() is way faster than reading /proc/meminfo, and it's an
> important improvement since right now fsck performance is still quite a
> bit lower in userspace than in the kernel.
>
> If you know of an equivalent interface on musl...

I think I'd better read the patch properly and properly understand his  
heuristic before suggesting anything!

There's si_meminfo() for the /proc/meminfo information... and I think he's  
already using that rather than mallinfo2() for all the values formerly  
read from /proc/meminfo.

Seems like the mallinfo2() is only being used for malloc_info.arena, which  
is understandably glibc-specific as it's an internal implementation detail  
of glibc's malloc implementation.

Best wishes,

Chris.
