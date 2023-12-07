Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B9BD73
	for <linux-bcachefs@vger.kernel.org>; Thu,  7 Dec 2023 00:24:19 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 25121)
	id B4CBF5877546F; Thu,  7 Dec 2023 09:24:16 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id B3A8860C23DC0;
	Thu,  7 Dec 2023 09:24:16 +0100 (CET)
Date: Thu, 7 Dec 2023 09:24:16 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
cc: Chris Webb <chris@arachsys.com>, Daniel Hill <daniel@gluo.nz>, 
    linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs-tools 1.3.5 FTBFS
In-Reply-To: <20231207081401.w44znpjbndiomrg4@moria.home.lan>
Message-ID: <s3r6oq8n-o50n-0nrp-n543-4010129r42qq@vanv.qr>
References: <rpq876s0-37r5-5099-6q6r-p3n36r7rr701@vanv.qr> <85FBC6E4-174C-46B5-8D7E-C7FE77124C7D@arachsys.com> <20231207081401.w44znpjbndiomrg4@moria.home.lan>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Thursday 2023-12-07 09:14, Kent Overstreet wrote:
>
>yeah, it's a change Daniel made to speed up memory allocation -
>mallinfo2() is way faster than reading /proc/meminfo, and it's an
>important improvement since right now fsck performance is still quite a
>bit lower in userspace than in the kernel.
>
>If you know of an equivalent interface on musl...

It's *musl*. There won't be such a thing.

The "equivalent" interface is fopen("/proc/meminfo","r").
