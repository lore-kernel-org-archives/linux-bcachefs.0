Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF62BD;
	Tue, 12 Dec 2023 23:38:33 -0800 (PST)
Received: from [141.14.31.7] (theinternet.molgen.mpg.de [141.14.31.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: buczek)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id F124D61E5FE04;
	Wed, 13 Dec 2023 08:37:57 +0100 (CET)
Message-ID: <a0f820a7-3cf5-4826-a15b-e536abb5b1de@molgen.mpg.de>
Date: Wed, 13 Dec 2023 08:37:57 +0100
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: file handle in statx
To: Theodore Ts'o <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>, NeilBrown <neilb@suse.de>,
 Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org,
 Stefan Krueger <stefan.krueger@aei.mpg.de>,
 David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org
References: <20231208024919.yjmyasgc76gxjnda@moria.home.lan>
 <630fcb48-1e1e-43df-8b27-a396a06c9f37@molgen.mpg.de>
 <20231208200247.we3zrwmnkwy5ibbz@moria.home.lan>
 <170233460764.12910.276163802059260666@noble.neil.brown.name>
 <20231211233231.oiazgkqs7yahruuw@moria.home.lan>
 <170233878712.12910.112528191448334241@noble.neil.brown.name>
 <20231212000515.4fesfyobdlzjlwra@moria.home.lan>
 <170234279139.12910.809452786055101337@noble.neil.brown.name>
 <ZXf1WCrw4TPc5y7d@dread.disaster.area>
 <e07d2063-1a0b-4527-afca-f6e6e2ecb821@molgen.mpg.de>
 <20231212152016.GB142380@mit.edu>
Content-Language: en-US, de-DE
From: Donald Buczek <buczek@molgen.mpg.de>
In-Reply-To: <20231212152016.GB142380@mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/12/23 16:20, Theodore Ts'o wrote:
> On Tue, Dec 12, 2023 at 10:10:23AM +0100, Donald Buczek wrote:
>> On 12/12/23 06:53, Dave Chinner wrote:
>>
>>> So can someone please explain to me why we need to try to re-invent
>>> a generic filehandle concept in statx when we already have a
>>> have working and widely supported user API that provides exactly
>>> this functionality?
>>
>> name_to_handle_at() is fine, but userspace could profit from being
>> able to retrieve the filehandle together with the other metadata in
>> a single system call.
> 
> Can you say more?  What, specifically is the application that would
> want to do that, and is it really in such a hot path that it would be
> a user-visible improveable, let aloine something that can be actually
> be measured?

Probably not for the specific applications I mentioned (backup, mirror,
accounting). These are intended to run continuously, slowly and unnoticed
in the background, so they are memory and i/o throttled via cgroups anyway
and one is even using sleep after so-and-so many stat calls to reduce
its impact.

If they could tell a directory from a snapshot, I would probably stop them
from walking into snapshots. And if not, the snapshot id is all that is
needed to tell a clone in a snapshot from a hardlink. So these don't really
need the filehandle.

In the thread it was assumed, that there are other (unspecified)
applications which need the filehandle and currently use name_to_handle_at().

I though it was self-evident that a single syscall to retrieve all
information atomically is better than a set of syscalls. Each additional
syscall has overhead and you need to be concerned with the data changing
between the calls.

Userspace nfs server as an example of an application, where visible
performance is more relevant, was already mentioned by someone else.

Best
  Donald


> 
> 						- Ted
-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433

