Received: from cdw.me.uk (cdw.me.uk [91.203.57.136])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 41D5DC6
	for <linux-bcachefs@vger.kernel.org>; Thu,  7 Dec 2023 00:36:00 -0800 (PST)
Received: from [148.252.147.228] (helo=smtpclient.apple)
	by delta.arachsys.com with esmtpa (Exim 4.80)
	(envelope-from <chris@arachsys.com>)
	id 1rB9rT-0001Mv-Te; Thu, 07 Dec 2023 08:36:00 +0000
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
In-Reply-To: <s3r6oq8n-o50n-0nrp-n543-4010129r42qq@vanv.qr>
Date: Thu, 7 Dec 2023 08:35:58 +0000
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Daniel Hill <daniel@gluo.nz>,
 linux-bcachefs@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <F49E622E-81B7-43B8-99F7-36AC15942CAA@arachsys.com>
References: <rpq876s0-37r5-5099-6q6r-p3n36r7rr701@vanv.qr>
 <85FBC6E4-174C-46B5-8D7E-C7FE77124C7D@arachsys.com>
 <20231207081401.w44znpjbndiomrg4@moria.home.lan>
 <s3r6oq8n-o50n-0nrp-n543-4010129r42qq@vanv.qr>
To: Jan Engelhardt <jengelh@inai.de>
X-Mailer: Apple Mail (2.3654.120.0.1.15)

Jan Engelhardt <jengelh@inai.de> wrote:

>
> On Thursday 2023-12-07 09:14, Kent Overstreet wrote:
>> yeah, it's a change Daniel made to speed up memory allocation -
>> mallinfo2() is way faster than reading /proc/meminfo, and it's an
>> important improvement since right now fsck performance is still quite a
>> bit lower in userspace than in the kernel.
>>
>> If you know of an equivalent interface on musl...
>
> It's *musl*. There won't be such a thing.
>
> The "equivalent" interface is fopen("/proc/meminfo","r").

Potentially we can do something sane here as we only want the total heap  
size anyway, for an equivalent to malloc_info.arena.

Best wishes,

Chris.
