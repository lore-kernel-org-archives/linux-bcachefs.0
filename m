Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F36CB9
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Dec 2023 02:48:04 -0800 (PST)
Received: from [192.168.1.123] (ip5b4280bd.dynamic.kabel-deutschland.de [91.66.128.189])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: buczek)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 3EC9B61E646C3;
	Mon,  4 Dec 2023 11:47:43 +0100 (CET)
Message-ID: <3b2720ca-23eb-4666-b04f-5bff4b1ac1cf@molgen.mpg.de>
Date: Mon, 4 Dec 2023 11:47:42 +0100
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: How to cope with subvolumes and snapshots on muti-user systems?
Content-Language: en-US
To: NeilBrown <neilb@suse.de>, Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Stefan Krueger <stefan.krueger@aei.mpg.de>
References: <3222cf4b-8f9d-4576-b2e2-c78e5655f4dc@molgen.mpg.de>
 <20231129214328.efbfpl3javifvwk5@moria.home.lan>
 <63ca9346-6bec-40d5-8f7e-4181721652f1@molgen.mpg.de>
 <20231130073948.v3jkmmvtwnefwvq3@moria.home.lan>
 <170137665630.7109.15666373159604652834@noble.neil.brown.name>
From: Donald Buczek <buczek@molgen.mpg.de>
In-Reply-To: <170137665630.7109.15666373159604652834@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/30/23 21:37, NeilBrown wrote:
> On Thu, 30 Nov 2023, Kent Overstreet wrote:
>> On Thu, Nov 30, 2023 at 08:35:12AM +0100, Donald Buczek wrote:
>>> On 11/29/23 22:43, Kent Overstreet wrote:
>>>> On Tue, Nov 28, 2023 at 08:49:23AM +0100, Donald Buczek wrote:
>>>>> Hi,
>>>>>
>>>>> I'm happy, bcachefs finally made it to mainline, Kudos to Kent!
>>>>>
>>>>> As far as I know, there is an ongoing discussion about the problems of non-unique inode numbers exposed by snapshots an no real conclusion yet, on how filesystems should expose snapshots.
>>>>>
>>>>> The current behavior is kind of a showstopper for us, because we are still running multi-user systems. The problem is, that any unprivileged user can create subvolumes and snapshots:
>>>>>
>>>>>       buczek@dose:/scratch/local3$ bcachefs subvolume create vol1
>>>>>       buczek@dose:/scratch/local3$ mkdir vol1/dir1
>>>>>       buczek@dose:/scratch/local3$ bcachefs subvolume snapshot vol1/snp1
>>>>>       buczek@dose:/scratch/local3$ ls -li vol1/
>>>>>       total 0
>>>>>       1342189197 drwxrwxr-x 2 buczek buczek 0 Nov 20 15:01 dir1
>>>>>       1476413180 drwxrwxr-x 3 buczek buczek 0 Nov 20 15:01 snp1
>>>>>       buczek@dose:/scratch/local3$ ls -li vol1/snp1/
>>>>>       total 0
>>>>>       1342189197 drwxrwxr-x 2 buczek buczek 0 Nov 20 15:01 dir1
>>>>>       buczek@dose:/scratch/local3$ find .
>>>>>       .
>>>>>       ./vol1
>>>>>       find: File system loop detected; ‘./vol1/snp1’ is part of the same file system loop as ‘./vol1’.
>>>>>       ./vol1/dir1
>>>>>       buczek@dose:/scratch/local3$
>>>>>
>>>>> We have a few tools which walk over the filesystem (backup, mirror, accounting) and these are just not prepared for non-unique inode numbers aside from regular hardlinks. I'm concerned that experiments of a unprivileged users could make important tools to fail.
>>>>>
>>>>> Questions:
>>>>>
>>>>> - Would it be a workaround to make creation of subvolumes and snapshots privileged operations?
>>>>>
>>>>> - If we want to evolve our tools: What is the best way for userspace to recognize subvolumes and snapshots and tell them apart from ordinary directories?
>>>>
>>>> I'm considering writing an "integer identifiers considered harmful"
>>>> paper. I haven't dug into it yet - just skimmed the lwn coverage - but
>>>> adding in the overlayfs issue makes this problem sound fundamentally
>>>> unsolvable given the current constraints.
>>>>
>>>> Recognizing subvolume boundaries: we don't have anything for this yet,
>>>> and given what happened with btrfs I'm not sure we want to go that
>>>> route.
>>>
>>> A fabricated fsid - I think, that is what btrfs does - wouldn't help
>>> us either. The mentioned tools would just stop at the assumed mount
>>> points.
>>
>> *nod* - nor for NFS.
>>
>>>> We could (probably) expose unique inode numbers, filesystem wide, but at
>>>> a cost. We'd have to restrict ourselves internally to 32 bit inode
>>>> numbers, and then report inode numbers that include the subvolume ID as
>>>> the high 32 bits.
>>>>
>>>> That won't leave enough bits to shard inode numbers at create time based
>>>> on CPU id, which isn't the _most_ important optimization, but would hurt
>>>> to lose.
>>>>
>>>> Going forward, we really need - as you allude to - better userspace
>>>> APIs. Inode number probably can't be an integer anymore, it needs to be
>>>> a string if it's going to be able to do all the things we want it to do.
>>>
>>> Should be an uuid then. Expose inode uuid (and/or snapshot uuid) via
>>> xattr? Anyway, I know, people more competent than me are thinking
>>> about the problem.
>>
>> Exposing the subvolume ID via an xattr would be easy, if that works for
>> you.
> 
> I think that would be a bad choice.  Stick with the filehandle.  It is
> an existing interface supported by many filesystems and it works over
> NFS.


Hmm, isn't a (struct file_handle) filehandle supposed to be opaque?  I'm not sure if it is a good idea to stick filesystem-specific meta-information (like a subvolume ident) into special bits of opaque numbers (whether inode number or filehandle) at all.

The information could also be made available via specialized ioctl(s) as an alternative to xattr.

One disadvantage of embedded in filehandle, xattr or ioctl is that userspace would need an extra syscall for each directory just to see if this is a subvolume or a snapshot, which most of the time it is not. Maybe, even an otherwise unnecessary open is needed to get a consistent view between multiple information-retrieving syscalls. If only statx() was extendable.

You don't have this problem with a crafted fsid. Then creating a subvolume or a snapshot could be seen as an implied mount. Maybe that's not the worst solution.

Best

   Donald

> 
> NeilBrown
> 
> 
>>
>>> What to you think about the suggestion to make creation of snapshots
>>> (and possible volumes, not sure about that) a privileged operation
>>> (optional, of course) ? I know, multi-user is niche nowadays, but for
>>> me it looks like a rather cheap workaround.
>>
>> Yeah, that's not an unreasonable ask.
>>
> 

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
